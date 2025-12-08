from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.orm import relationship

from app.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, index=True, nullable=False)
    password = Column(String(255), nullable=False)
    nickname = Column(String(100), nullable=False)
    
    about = Column(Text, nullable=True)
    profile_image = Column(String(255), nullable=True)

    # ✨ 시연용 카운트 컬럼
    post_count = Column(Integer, default=0, nullable=False)
    comment_count = Column(Integer, default=0, nullable=False)
    follower_count = Column(Integer, default=0, nullable=False)

    # 게시글 관계
    posts = relationship("Post", back_populates="user")
