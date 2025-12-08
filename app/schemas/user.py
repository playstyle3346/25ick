from pydantic import BaseModel
from typing import Optional

class UserBase(BaseModel):
    email: str
    nickname: str


class UserCreate(UserBase):
    password: str


class UserLogin(BaseModel):
    email: str
    password: str


class UserRead(UserBase):
    id: int
    about: Optional[str] = None
    profile_image: Optional[str] = None

    class Config:
        from_attributes = True


class UserUpdate(BaseModel):
    nickname: Optional[str] = None
    about: Optional[str] = None
    profile_image: Optional[str] = None


class Token(BaseModel):
    access_token: str
    token_type: str
