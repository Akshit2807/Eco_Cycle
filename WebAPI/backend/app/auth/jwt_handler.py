from fastapi import HTTPException, status, Depends
from fastapi.security import OAuth2PasswordBearer
import firebase_admin
from firebase_admin import credentials, auth
import os

UNIVERSAL_TOKEN = os.environ.get("UNIVERSAL_TOKEN") 
curr_dir = os.environ.get("SERVICE_ACC_STORED_AT") 
SERVICE_ACC_PATH = os.path.join(curr_dir, "service-acc.json")
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")


cred = credentials.Certificate(SERVICE_ACC_PATH)
firebase_admin.initialize_app(cred)

def decode_access_token(token: str):    
    if token == UNIVERSAL_TOKEN:
        return {"name":"BuriBurizaemon","sub": "universal_user", "role": "admin", "exp": None}

    try:
        decoded_token = auth.verify_id_token(token, check_revoked=True)
        return decoded_token  

    except auth.ExpiredIdTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token has expired",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    except auth.RevokedIdTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token has been revoked",
            headers={"WWW-Authenticate": "Bearer"},
        )

    except auth.InvalidIdTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,    
            detail="Invalid token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Token format is incorrect",
            headers={"WWW-Authenticate": "Bearer"},
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Token verification failed: {str(e)}",
            headers={"WWW-Authenticate": "Bearer"},
        )

def get_current_user(token: str = Depends(oauth_scheme)):
    payload = decode_access_token(token)
    return payload
