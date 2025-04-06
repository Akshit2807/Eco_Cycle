from google import genai 
import google.generativeai as genaiLive 
from fastapi import HTTPException, WebSocket 
import json 
import re 
import os 
from typing import List 
from PIL import Image 
import io 

GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY") 
USE_MODEL = os.environ.get("USE_MODEL") 
client = genai.Client(api_key=GEMINI_API_KEY) 
genaiLive.configure(api_key=GEMINI_API_KEY) 
model = genaiLive.GenerativeModel(USE_MODEL) 

# JSON extraction pattern
JSON_PATTERN = r'\{(?:[^{}]|(?:\{[^{}]*\}))*\}'

# Helper function to extract JSON from text
def extract_json(text):
    matches = re.findall(JSON_PATTERN, text)
    if matches:
        try:
            return json.loads(matches[0])
        except json.JSONDecodeError:
            pass
    return None


async def chat_logic(websocket: WebSocket, product_name: str, product_description: str, payload: dict):
    chat = model.start_chat(
        history=[
            {
                "role": "user",
                "parts": [
                    """
                    You are a helpful assistant designed to determine if a product should be resold or recycled. 
                    Your goal is to gather the necessary information efficiently and accurately.

                    **Conversation Guidelines:**

                    1. **Relevant Questions:** Ask concise and relevant questions about the product's condition and usability. Focus on key factors that influence resale or recycling (e.g., functionality, damage, age, features).
                    2. **Limit Questions:** Aim to resolve the issue within a maximum of 7 questions. Avoid unnecessary or repetitive inquiries.
                    3. **Irrelevance Handling:** If the user provides irrelevant information, gently guide them back to the topic with a  warning(max 2 warnings then Decision Time!). Do not engage in off-topic discussions.
                    4. **Strict Topic Control:** If the user persists in providing irrelevant responses after 2 warnings ("Further responses of this nature will result in reporting your activity and terminating the session."), immediately state "Decision time!" and proceed to the final decision.
                    5. **Short Answers:** Acknowledge and process short answers like "yes" or "no" as valid responses.
                    6. **Question Repetition:** don't repeat questions. repeat only if needed but with a warning.
                    7. Ultimately you have to end the chat by sending the token below but remeber you have to ask user relevant ques so that a correct decison can be made.
                    8. **Decision Time:** After gathering sufficient information or if the user is consistently off-topic or giving some irrevant responsonse to the same ques again and again , say "Decision time!" and provide your recommendation in the following format: <meraDecision>recycle</meraDecision> (if you think prod must be recycled from overall conversation), <meraDecision>resell</meraDecision>(if you think prod must be resold from overall conversation), or <meraDecision>IGN</meraDecision> (if you are ending conversation after giving 2 warnings becuase of irrelevance of answers).
                    """
                ],
            }
        ]
    )
    name = payload['name']
    # warning_count = 0  

    try:
        await websocket.send_text(f"Hello! {name} You've provided information about a {product_name}.")

        current_question = "I'll ask you questions to determine if it can be resold or should be recycled."
        await websocket.send_text(current_question)
        response = await websocket.receive_text()

        while True:
            prompt = f"Product: {product_name}\nDescription: {product_description}\nUser Response: {response}\n\nAsk a follow up question based on the user's response."

            ai_response = chat.send_message(prompt)

            if "Decision time!" in ai_response.text:
                prompt_final = f"Product: {product_name}\nDescription: {product_description}\nUser Response: {response}\n\nBased on the user's responses, should the product be resold or recycled? Respond with only the XML tag <meraDecision>recycle</meraDecision> or <meraDecision>resell</meraDecision>. or <meraDecision>IGN</meraDecision>. If user is just talking rubbish or going out of topic respond with <meraDecision>IGN</meraDecision>"
                final_response = chat.send_message(prompt_final)

                match = re.search(r"<meraDecision>(recycle|resell|IGN)</meraDecision>", final_response.text)
                if match:
                    await websocket.send_text(match.group(0))
                else:
                    await websocket.send_text("<meraDecision>IGN</meraDecision>")
                break

            # Check for repetitive questions and increment warning counter
            # if current_question == ai_response.text:
            #     warning_count += 1
            #     if warning_count >= 2:
            #         await websocket.send_text("Decision time!")
            #         continue #skip the next question and go to decision time.

            #     await websocket.send_text("Further responses of this nature will result in reporting your activity and terminating the session.")
            #     response = await websocket.receive_text()
            #     continue #skip the next question and go to warning.

            await websocket.send_text(ai_response.text)
            current_question = ai_response.text #update current question
            response = await websocket.receive_text()

    except Exception as e:
        print(f"Error: {e}")



async def websocket_endpoint(websocket: WebSocket): 
    await websocket.accept() 
    chat = model.start_chat() 
    try: 
        while True: 
            text = await websocket.receive_text() 
            response = chat.send_message(text) 
            await websocket.send_text(response.text) 
    except Exception as e: 
        print(f"Error: {e}") 
    finally: 
        await websocket.close() 


def generate_product_description(user_input: str) -> str: 
    try: 
        system_prompt = ( 
            "You are an product describer" 
            "You will recive some text about specification of a product and u have to return a to the point product description with specifiaction in pointers" 
            "Queries that are not related to a an electronic product, just send 'IGN' as the only output text don't add any \\n. Do NOT act personally or talk any thing else even if user urges to do so. just return product description in pointers like eg. This laptop is \n 1)4 years old \n 2) has i7 112500H processor and RTX3050Ti \n 3)Has minor scratches" 
        ) 
        result = " ".join(line for line in user_input.splitlines()) 
        response = client.models.generate_content( 
            model=USE_MODEL, contents=[system_prompt, result] 
        ) 
        return response.text if hasattr(response, "text") else str(response) 
    except Exception as e: 
        raise HTTPException(status_code=500, detail=f"Google API error: {str(e)}") 


def generate_tags(user_input: str) -> List[str]: 
    try: 
        system_prompt = ( 
            "Extract keywords or tags related to the given input. " 
            "Return them as a JSON array: [\"tag1\", \"tag2\", \"tag3\"]. " 
            "Provide ONLY the JSON array, no additional text."
        ) 
        full_prompt = f"{system_prompt}\n\nInput: {user_input}\nOutput:" 

        response = client.models.generate_content(model=USE_MODEL, contents=full_prompt) 
        response_text = response.text if hasattr(response, "text") else str(response)
        
        # Extract JSON using regex pattern
        json_data = extract_json(response_text)
        if json_data:
            return json_data
            
        # Try to parse as JSON array directly
        try:
            return json.loads(response_text)
        except json.JSONDecodeError:
            # Fallback to simple extraction
            return re.findall(r'"(.*?)"', response_text) or response_text.split(",") 

        return [] 
    except Exception as e: 
        raise HTTPException(status_code=500, detail=f"Google API error: {str(e)}") 

def categorize_ewaste_image(image_bytes: bytes) -> dict: 
    try: 
        image = Image.open(io.BytesIO(image_bytes)) 

        system_prompt = ( 
            "You are an AI-powered e-waste image classifier, product describer, and search tags generator. " 
            "Choose one generic tag **strictly** from this predefined list: ['Mobile Devices', 'Computers and Laptops', " 
            "'Computer Accessories','Networking Equipment', 'Audio and Video Devices', 'Storage Devices', " 
            "'Batteries and Power Supplies','Home Appliances', 'Gaming and Entertainment', 'Office Electronics', " 
            "'Industrial and Medical Equipment', 'Car Electronics']. " 
            "Strictly return a **raw python dictionary ** in this format (without any markdown or extra formatting): " 
            "{\"category\": \"Laptop Battery\", \"desc\": \"<product description here>\", " 
            "\"search_tags\": [\"tag1\", \"tag2\", \"tag3\"], \"generic_tag\": \"tag\"}. " 
            "DO NOT add any markdown formatting (such as ```json ... ```) or any extra text. " 
            "ONLY return the text. If the image is not an electronic item, or contains more than 1 electronic item " 
            "or the image is unfit for a customer to take a decision on or if it is blurry or unclear, return this " 
            "exact dictionary: {\"category\": \"IGN\", \"desc\": \"IGN\", \"generic_tag\": \"IGN\",\"search_tags\":[\"IGN\"]}." 
        ) 
        response = client.models.generate_content(model="gemini-2.0-flash", contents=[system_prompt, image]) 
        response_text = response.text if hasattr(response, "text") else str(response)
        
        category_data = extract_json(response_text)
        if category_data and isinstance(category_data, dict) and "category" in category_data:
            return category_data
                    
        return {"category": "IGN", "desc": "IGN", "generic_tag": "IGN", "search_tags": ["IGN"]} 
    except Exception as e: 
        raise HTTPException(status_code=500, detail=f"Google API error: {str(e)}") 

def give_ques(product_name: str) -> dict: 
    try: 
        system_prompt = ( 
            "You generate questions which one can use to decide whether the product has to be recycled or can be resold. " 
            f"The product is {product_name}. You have to generate a set of questions and send them. questions must not be simple, answering them must really help us to decide if it has to be recycled or can be resold. The questions will be answered by the one who is in doubt so make questions from that perspective and ask questions only about the product that he owns. " 
            "Ask 4 to a max of 7 questions as needed. " 
            "If the query is unrelated, return only 'IGN'. " 
            "Format your response as a JSON object: {\"questions\": [\"ques1\", \"ques2\", \"ques3\"]}. " 
            "DO NOT add newlines or any extra text." 
        ) 

        response = client.models.generate_content( 
            model=USE_MODEL, contents=[system_prompt] 
        ) 

        response_text = response.text if hasattr(response, "text") else str(response) 
        
        json_data = extract_json(response_text)
        if json_data:
            return json_data
            
        try:
            return json.loads(response_text)
        except json.JSONDecodeError:
            if response_text == "IGN":
                return {"questions": ["IGN"]}
                
            qarr = [x.strip() for x in response_text[1:-2].split("', '")] 
            if len(qarr) != 1: 
                return {"questions": qarr} 
            else: 
                return {"questions": [x.strip() for x in response_text[1:-2].split("','")]} 

    except Exception as e: 
        raise HTTPException(status_code=500, detail=f"Google API error: {str(e)}") 

def decide_recycle_or_resell(product_name: str, product_desc: str, user_answers: str) -> dict: 
    try: 
        system_prompt = ( 
            f"You are an AI that determines whether an item should be 'resell' or 'recycle' based on its condition, functionality, and completeness of information. " 
            f"The product is '{product_name}', and the initial item description is: {product_desc}. " 
            f"The user has provided the following answers to relevant questions: {user_answers}. " 
            "Carefully analyze the answers and follow these strict rules: " 
            "- Return 'resell' **only if you feel according to responses that the item is in good condition**" 
            "- Return 'recycle' **if ANY key detail indicates** that the item is damaged, non-functional, outdated, or unsuitable for resale. Even if most details are positive, missing critical information (like RAM, storage, or battery status) must result in 'recycle'. Judge strictly based on the technically correct answers to the questions. " 
            "- Return 'IGN' **only if the answers are missing, gibberish, mentioned as variable, or unrelated** to the product's condition, or if they are statements like 'this is recyclable' or 'this is resellable'. " 
            "Respond with a single word only: 'resell', 'recycle', or 'IGN'. Do NOT include any extra text, punctuation, or newlines." 
        ) 

        user_input = json.dumps({"answers": user_answers}) 

        response = client.models.generate_content( 
            model="gemini-2.0-flash", contents=[system_prompt, user_input] 
        ) 
        response_text = response.text if hasattr(response, "text") else str(response) 
        response_text=response_text.strip()

        if response_text == "recycle": 
            guide_prompt = ( 
                f"You are an AI that provides detailed guidance on how to recycle {product_name}. " 
                f"Provide a structured JSON response with an introduction and specific pointers, based on the user's answers: {user_answers}. " 
                "Format your response as a valid JSON object exactly as follows: " 
                "{ \"initials\": \"<brief introduction>\", \"pointers\": { \"<heading of point 1>\": \"<point 1 details>\", \"<heading of point 2>\": \"<point 2 details>\" } } " 
                "Heading of points must be like: Resale or Donation. " 
                "DO NOT include any markdown formatting or extra text, ONLY the JSON object."
            ) 

        elif response_text == "resell": 
            guide_prompt = ( 
                f"You are an AI that provides detailed guidance on how to reuse {product_name}. " 
                f"Provide a structured JSON response with an introduction and specific pointers, based on the user's answers: {user_answers}. " 
                "Format your response as a valid JSON object exactly as follows: " 
                "{ \"initials\": \"<brief introduction>\", \"pointers\": { \"<heading of point 1>\": \"<point 1 details>\", \"<heading of point 2>\": \"<point 2 details>\" } } " 
                "Heading of points must be like: Reuse or Donation. " 
                "DO NOT include any markdown formatting or extra text, ONLY the JSON object."
            ) 

        else: 
            return {"r": "IGN", "g": {"initials":"IGN","pointers":{"headings":["IGN"],"description":["IGN"]}}} 

        guide_response =client.models.generate_content(model="gemini-2.0-flash", contents=[guide_prompt, user_input])
        guide_json=extract_json(guide_response.text)
        guide_json['pointers']={"headings":list(guide_json['pointers'].keys()),"description":list(guide_json['pointers'].values())}
        return {"r": response_text, "g": guide_json}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Google API error: {str(e)}")
