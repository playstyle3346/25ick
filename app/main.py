from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app.routers.auth import router as auth_router
from app.routers.post_router import router as post_router
from app.database import Base, engine
from app.models import user, post_model  # 모델 로드

app = FastAPI()

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# DB 테이블 생성
Base.metadata.create_all(bind=engine)

# 라우터 등록
app.include_router(auth_router, prefix="/auth", tags=["Auth"])
app.include_router(post_router, prefix="/posts", tags=["Posts"])

# 정적파일 폴더 연결
app.mount("/static", StaticFiles(directory="uploads"), name="static")
