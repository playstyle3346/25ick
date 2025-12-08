from pydantic import BaseModel
from datetime import datetime


# -------------------------------
# 게시글 생성 요청
# -------------------------------
class PostCreate(BaseModel):
    title: str
    content: str


# -------------------------------
# 게시글 조회 응답
# -------------------------------
class PostRead(BaseModel):
    id: int
    user_id: int
    title: str
    content: str
    created_at: datetime

    class Config:
        from_attributes = True