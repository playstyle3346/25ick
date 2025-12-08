from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from app.database import get_db
from app.models.post_model import Post
from app.schemas.post import PostCreate, PostRead
from app.routers.auth import get_current_user
from app.models.user import User

router = APIRouter()

def get_current_user_id(current_user: User = Depends(get_current_user)) -> int:
    return current_user.id

@router.get("/")
def posts_root():
    return {"message": "Posts router is working!"}

@router.post("/create", response_model=PostRead, status_code=status.HTTP_201_CREATED)
def create_post(
    post_in: PostCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id)
):
    new_post = Post(
        user_id=user_id,
        title=post_in.title,
        content=post_in.content,
    )
    db.add(new_post)
    db.commit()
    db.refresh(new_post)
    return new_post

@router.get("/list", response_model=List[PostRead])
def list_posts(db: Session = Depends(get_db)):
    posts = db.query(Post).order_by(Post.created_at.desc()).all()
    return posts

@router.get("/{post_id}", response_model=PostRead)
def detail_post(post_id: int, db: Session = Depends(get_db)):
    post = db.query(Post).filter(Post.id == post_id).first()
    if not post:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "게시글을 찾을 수 없습니다.")
    return post
