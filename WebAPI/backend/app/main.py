from fastapi import FastAPI, HTTPException, Depends, WebSocket, Request, Response, Query
from pydantic import BaseModel
from typing import List
import base64
import json
import datetime
import logging
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import StreamingResponse
from zoneinfo import ZoneInfo

# Import services and authentication
from app.auth.jwt_handler import get_current_user, decode_access_token
from app.services.ai_service import *

# Initialize FastAPI
# app = FastAPI()

# Set up logging
# logging.basicConfig(filename="logs.json", level=logging.INFO, format="%(message)s")

# IST = ZoneInfo("Asia/Kolkata")  # India's timezone

# Initialize FastAPI
# app = FastAPI()

# Configure logging
LOG_FILE = "logs.json"
logging.basicConfig(filename=LOG_FILE, level=logging.INFO, format="%(message)s")

# Timezone configuration
IST = ZoneInfo("Asia/Kolkata")

import asyncio
import json
import datetime
import logging
from logging.handlers import RotatingFileHandler
from fastapi import FastAPI, HTTPException, Request, Query
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import StreamingResponse
from zoneinfo import ZoneInfo

# Timezone configuration
# IST = ZoneInfo("Asia/Kolkata")

# Constants
# LOG_FILE = "logs.json"
LOG_RETENTION_HOURS = 5
LOG_PRUNE_INTERVAL = 300  # Run pruning every 5 minutes

# Initialize FastAPI
app = FastAPI()

# Configure rotating log handler to limit size and number of backup files
log_handler = RotatingFileHandler(LOG_FILE, maxBytes=100*1024*1024 , backupCount=3)
logging.basicConfig(handlers=[log_handler], level=logging.INFO, format="%(message)s")


class LogMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        """ Middleware to log requests and responses """
        if request.url.path == "/logs":
            return await call_next(request)
        
        start_time = datetime.datetime.now(IST)  

        try:
            body_bytes = await request.body()
            request_body = body_bytes.decode("utf-8") if body_bytes else None
        except Exception as e:
            request_body = f"Error reading body: {str(e)}"

        request_data = {
            "time": start_time.isoformat(),
            "method": request.method,
            "url": str(request.url),
            "headers": dict(request.headers),
            "body": request_body,
        }

        try:
            response = await call_next(request)

            response_body = [chunk async for chunk in response.body_iterator]
            response_content = b"".join(response_body).decode("utf-8") if response_body else None

            new_response = StreamingResponse(
                iter(response_body), status_code=response.status_code, headers=dict(response.headers)
            )

            request_data["status_code"] = response.status_code
            request_data["response_body"] = response_content

            # Append log without pruning in every request
            logging.info(json.dumps(request_data))

            return new_response

        except Exception as e:
            request_data["error"] = str(e)
            request_data["status_code"] = 500
            logging.error(json.dumps(request_data))
            raise HTTPException(status_code=500, detail="Internal Server Error")


app.add_middleware(LogMiddleware)


async def prune_old_logs():
    """ Periodically remove logs older than 5 hours """
    while True:
        try:
            now = datetime.datetime.now(IST)
            cutoff_time = now - datetime.timedelta(hours=LOG_RETENTION_HOURS)
            valid_logs = []

            # Read and filter logs
            with open(LOG_FILE, "r", encoding="utf-8") as file:
                for line in file:
                    try:
                        log_entry = json.loads(line.strip())
                        log_time = datetime.datetime.fromisoformat(log_entry["time"]).replace(tzinfo=IST)
                        if log_time >= cutoff_time:
                            valid_logs.append(log_entry)
                    except json.JSONDecodeError:
                        continue  # Skip corrupt entries

            # Rewrite filtered logs
            with open(LOG_FILE, "w", encoding="utf-8") as file:
                for log in valid_logs:
                    file.write(json.dumps(log) + "\n")

        except FileNotFoundError:
            pass  # No logs to prune if file doesn't exist
        except Exception as e:
            logging.error(f"Error pruning logs: {e}")

        await asyncio.sleep(LOG_PRUNE_INTERVAL)  # Run every 5 minutes


@app.on_event("startup")
async def startup_event():
    """ Start log pruning in the background on server start """
    asyncio.create_task(prune_old_logs())


@app.get("/logs")
async def get_logs(
    start_time: str = Query(..., description="Start time in ISO format (YYYY-MM-DDTHH:MM:SS)"),
    end_time: str = Query(..., description="End time in ISO format (YYYY-MM-DDTHH:MM:SS)")
):
    try:
        start_dt = datetime.datetime.fromisoformat(start_time).replace(tzinfo=IST)
        end_dt = datetime.datetime.fromisoformat(end_time).replace(tzinfo=IST)

        logs = []
        with open(LOG_FILE, "r", encoding="utf-8") as file:
            for line in file:
                try:
                    log_entry = json.loads(line.strip())
                    log_time = datetime.datetime.fromisoformat(log_entry["time"]).replace(tzinfo=IST)
                    if start_dt <= log_time <= end_dt:
                        logs.append(log_entry)
                except json.JSONDecodeError:
                    continue  # Skip invalid entries

        return {"message": "Logs fetched successfully", "logs": logs}

    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Invalid date format: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")




class DescriptionInput(BaseModel): 
    """Model for receiving text input from users."""
    prod_desc_by_user: str

class DescriptionResponse(BaseModel):
    """Response model for AI-generated product description."""
    description: str

class BlogDataInput(BaseModel):
    """Model for receiving text input from users."""
    blog: str

class BlogDataResponse(BaseModel):
    """Model for AI-generated tags for blogs."""
    tags: List[str]

class ImageDataInput(BaseModel):
    """Model for receiving base64-encoded images."""
    image_base64: str

class QuestionGetterInput(BaseModel):
    """Model for receiving title name for generating questions."""
    title: str

class DecisionInput(BaseModel):
    """Model for decision-making based on product name and Q&A."""
    title: str
    initial_prod_description: str
    qnas: str  # Serialized list of answers from the user

class DecisionResponse(BaseModel):
    """Response model for item decision (Recycle or Resell)."""
    decision: str
    guide: dict  # Optional additional guidance if applicable

class ImageDataResponse(BaseModel):
    """Response model for e-waste categorization."""
    title: str
    desc: str
    search_tags: List[str] | None = None
    category: str

class QuestionGetterResponse(BaseModel):
    """Response model for AI-generated questions."""
    questions: List[str]

@app.post("/ai/generate_description", response_model=DescriptionResponse)
async def generate_description(data: DescriptionInput, current_user: dict = Depends(get_current_user)):
    """
    Generate a product description from user input.
    - **prod_desc_by_user**: Text of description of the product.
    - **Returns**: A dictionary containing the AI-generated description.
    """
    try:
        return DescriptionResponse(description=generate_product_description(data.prod_desc_by_user))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/ai/generate_blog_tags", response_model=BlogDataResponse)
async def generate_tags_endpoint(data: BlogDataInput, current_user: dict = Depends(get_current_user)):
    """
    Generate relevant search tags from user input.
    - **blog**: Text of the blog.
    - **Returns**: A dictionary containing a list of AI-generated tags.
    """
    try:
        return BlogDataResponse(tags=generate_tags(data.blog))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# @app.post("/ai/categorize_ewaste_base64", response_model=ImageDataResponse)
# async def categorize_e_waste_base64(image_data: ImageDataInput, current_user: dict = Depends(get_current_user)):
#     """
#     Categorize an e-waste item based on an image.
#     - **image_base64**: Base64-encoded image.
#     - **Returns**: A dictionary with title, description, search tags, and generic tag.
#     """
#     try:
#         image_bytes = base64.b64decode(image_data.image_base64)
#         c=categorize_ewaste_image(image_bytes)
#         return ImageDataResponse(title=c['category'],desc=c['desc'],search_tags=c['search_tags'],category=c['category'])
#     except Exception as e:
#         raise HTTPException(status_code=400, detail=str(e))


@app.post("/ai/categorize_ewaste_base64", response_model=ImageDataResponse)
async def categorize_e_waste_base64(image_data: ImageDataInput, current_user: dict = Depends(get_current_user)):
    """
    Categorize an e-waste item based on an image.
    - **image_base64**: Base64-encoded image.
    - **Returns**: A dictionary with title, description, search tags, and generic tag.
    """
    try:
        image_bytes = base64.b64decode(image_data.image_base64)
        c = categorize_ewaste_image(image_bytes)

        if not isinstance(c, dict):
            raise HTTPException(status_code=500, detail="Invalid response from AI model")

        return ImageDataResponse(
            title=c.get('category', 'Unknown'),
            desc=c.get('desc', 'No description'),
            search_tags=c.get('search_tags', []),
            category=c.get('generic_tag', 'Unknown')
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/ai/get_questions", response_model=QuestionGetterResponse)
async def gen_ques(data: QuestionGetterInput, current_user: dict = Depends(get_current_user)):
    """
    Generate relevant questions based on the product name.
    - **title**: Name of the product.
    - **Returns**: A list of AI-generated questions.
    """
    try:
        return QuestionGetterResponse(questions=give_ques(data.title)['questions'])
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

async def authenticate_websocket(websocket: WebSocket):
    try:
        auth_header = websocket.headers.get("Authorization")
        if not auth_header:
            await websocket.close(code=4001)
            raise HTTPException(status_code=4001, detail="Authentication required")
        token = auth_header.split(" ")[1]
        payload = decode_access_token(token)
        logging.info(f"websocket payload:{payload}")
        return payload
    except HTTPException as e:
        await websocket.close(code=4001)
        raise e
    except Exception as e:
        await websocket.close(code=4001)
        raise HTTPException(status_code=4001, detail="Authentication failed")



# @app.websocket("/chatqa/{product_name}/{product_description}")
# async def chat_endpoint(websocket: WebSocket, product_name: str, product_description: str):
#     """WebSocket endpoint for live chat functionality."""
#     await websocket.accept() #moved accept here.
#     try:
#         payload = await authenticate_websocket(websocket)
#         if bool(payload):
#             await chat_logic(websocket, product_name, product_description, payload)
#     except Exception as e:
#         print(f"Error: {e}")
#     finally:
#         await websocket.close()


import asyncio
from websockets.exceptions import ConnectionClosedError, ConnectionClosedOK
from fastapi import FastAPI, WebSocket

@app.websocket("/chatqa/{product_name}/{product_description}")
async def chat_endpoint(websocket: WebSocket, product_name: str, product_description: str):
    await websocket.accept()
    try:
        payload = await authenticate_websocket(websocket)
        if bool(payload):
            await chat_logic(websocket, product_name, product_description, payload)
    except ConnectionClosedError:
        print("Connection Closed Error in endpoint")
    except ConnectionClosedOK:
        print("Connection Closed OK in endpoint")
    except Exception as e:
        print(f"Error in chat_endpoint: {e}")
    finally:
        await websocket.close()


@app.websocket("/chatqasmpl")
async def chat_endpoint(websocket: WebSocket):
    """WebSocket endpoint for live chat functionality."""
    try:
        await websocket_endpoint(websocket)
    except Exception as e:
        await websocket.close()


@app.post("/ai/decide", response_model=DecisionResponse)
async def decide_resell_or_recycle(data: DecisionInput, current_user: dict = Depends(get_current_user)):
    """
    Decide whether a product should be recycled or resold.
    - **title**: Name of the product.
    - **initial_prod_description**: Initial product description generated by AI after clicking the photo.
    - **qnas**: List of answers related to the product's condition.
    - **Returns**: Decision ('recycle' or 'resell') with optional guidance in JSON format.
    """
    try:
        decision = decide_recycle_or_resell(data.title, data.initial_prod_description, data.qnas)
        return DecisionResponse(decision=decision["r"], guide=decision["g"])
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    

