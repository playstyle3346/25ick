from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import os
from datetime import datetime

# 내부 라우터 및 DB 구성 import
from app.routers.auth import router as auth_router
from app.routers.post_router import router as post_router
from app.database import Base, engine
from app.models import user, post_model  # 모델 로드

app = FastAPI()

# -------------------------------------
# CORS 설정 (Flutter Web에서 필수)
# -------------------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 개발 중에는 전체 허용
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# -------------------------------------
# DB 테이블 생성
# -------------------------------------
Base.metadata.create_all(bind=engine)

# -------------------------------------
# 라우터 등록
# -------------------------------------
app.include_router(auth_router, prefix="/auth", tags=["Auth"])
app.include_router(post_router, prefix="/posts", tags=["Posts"])

# -------------------------------------
# 이미지 업로드 기능
# -------------------------------------
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)


@app.post("/upload-image")
async def upload_image(file: UploadFile = File(...)):
    """
    Flutter Web → 이미지 업로드 → 서버 uploads 폴더 저장 → URL 반환
    """
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    filename = f"{timestamp}_{file.filename}"
    file_path = os.path.join(UPLOAD_DIR, filename)

    # 파일 저장
    with open(file_path, "wb") as buffer:
        buffer.write(await file.read())

    file_url = f"http://127.0.0.1:8000/static/{filename}"

    return {"url": file_url}


# -------------------------------------
# 정적 파일(이미지) 경로 연결
# -------------------------------------
app.mount("/static", StaticFiles(directory="uploads"), name="static")
