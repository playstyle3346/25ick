from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.orm import Session
from jose import jwt, JWTError
import os
import time

# 내부 모듈 임포트
from app.database import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserRead, UserLogin, UserUpdate, Token
from app.core.security import (
    get_password_hash,
    verify_password,
    create_access_token,
    oauth2_scheme,
    SECRET_KEY,
    ALGORITHM,
)

router = APIRouter()

# -----------------------------
# 회원가입
# -----------------------------
@router.post("/register", response_model=UserRead, status_code=status.HTTP_201_CREATED)
def register_user(user_in: UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(User).filter(User.email == user_in.email).first()
    if existing_user:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "이미 가입된 이메일입니다.")

    hashed_pw = get_password_hash(user_in.password)

    new_user = User(
        email=user_in.email,
        password=hashed_pw,
        nickname=user_in.nickname,
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


# -----------------------------
# 로그인 (JWT 발급)
# -----------------------------
@router.post("/login", response_model=Token)
def login(user_in: UserLogin, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == user_in.email).first()

    if not user or not verify_password(user_in.password, user.password):
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            "이메일 또는 비밀번호가 올바르지 않습니다."
        )

    token = create_access_token(data={"sub": str(user.id)})
    return Token(access_token=token, token_type="bearer")


# -----------------------------
# 현재 로그인된 사용자 조회
# -----------------------------
def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
) -> User:
    """
    oauth2_scheme은 Bearer Token 문자열을 반환한다.
    이 토큰을 직접 decode하여 User 정보를 반환한다.
    """
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = payload.get("sub")

        if user_id is None:
            raise JWTError
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="유효하지 않은 인증 토큰입니다.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    user = db.query(User).filter(User.id == int(user_id)).first()
    if not user:
        raise HTTPException(404, "사용자를 찾을 수 없습니다.")

    return user


# -----------------------------
# 내 정보 조회
# -----------------------------
@router.get("/me", response_model=UserRead)
def read_me(current_user: User = Depends(get_current_user)):
    return current_user


# -----------------------------
# 프로필 수정
# -----------------------------
@router.put("/update", response_model=UserRead)
def update_user(
    update: UserUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    update_data = update.model_dump(exclude_unset=True)

    for key, value in update_data.items():
        setattr(current_user, key, value)

    db.commit()
    db.refresh(current_user)
    return current_user


# -----------------------------
# 프로필 이미지 업로드
# -----------------------------
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.post("/upload-profile")
def upload_profile(file: UploadFile = File(...)):
    filename = f"profile_{int(time.time())}_{file.filename.replace(' ', '_')}"
    filepath = os.path.join(UPLOAD_DIR, filename)

    try:
        with open(filepath, "wb") as f:
            f.write(file.file.read())
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="파일 저장에 실패했습니다."
        )

    return {"url": f"/static/{filename}"}

@router.post("/increase-comment", response_model=UserRead)
def increase_comment(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    current_user.comment_count += 1
    db.add(current_user)
    db.commit()
    db.refresh(current_user)
    return current_user

@router.post("/increase-follower", response_model=UserRead)
def increase_follower(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    current_user.follower_count += 1
    db.add(current_user)
    db.commit()
    db.refresh(current_user)
    return current_user


