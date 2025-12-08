from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# SQLite DB 경로 설정
# 실제 운영 환경에서는 PostgreSQL이나 MySQL 등을 사용해야 합니다.
SQLALCHEMY_DATABASE_URL = "sqlite:///./sql_app.db"

# engine 생성 (check_same_thread=False는 SQLite에서만 필요합니다)
engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)

# 세션 생성
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# 모든 모델의 기반 클래스
Base = declarative_base()

# Dependency: DB 세션을 생성하고 요청이 완료되면 닫아주는 함수
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()