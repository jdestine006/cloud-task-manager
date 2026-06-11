from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import text
from database import SessionLocal
from database import engine, Base
from models import Task

from sqlalchemy.orm import Session
from typing import List
from database import get_db
from models import Task
from schemas import TaskCreate



app = FastAPI(title="Cloud Task Manager")

Base.metadata.create_all(bind=engine)

# Service Health Check
@app.get("/")
def health_check():
    return {"status": "ok", "service": "cloud-task-manager"}

# DB Health Check
@app.get("/health/db")
def database_health_check():
    db = SessionLocal()

    try:
        db.execute(text("SELECT 1"))
        return {"database": "connected"}
    except Exception as e:
        return {
            "database": "error",
            "detail": str(e)
        }
    finally:
        db.close()

# Create Task
@app.post("/tasks")
def create_task(task: TaskCreate, db: Session = Depends(get_db)):
    db_task = Task(
        title=task.title,
        description=task.description,
        completed=False
    )

    db.add(db_task)
    db.commit()
    db.refresh(db_task)

    return {
        "id": db_task.id,
        "title": db_task.title,
        "description": db_task.description,
        "completed": db_task.completed
    }

# Get Current List of Tasks
@app.get("/tasks")
def get_tasks(db: Session = Depends(get_db)):
    tasks = db.query(Task).all()

    return {
        "tasks": [
            {
                "id": task.id,
                "title": task.title,
                "description": task.description,
                "completed": task.completed,
            }
            for task in tasks
        ]
    }

# Get Singular Task 
@app.get("/tasks/{task_id}")
def get_task(task_id: int, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == task_id).first()

    if task is None:
        raise HTTPException(status_code=404, detail="Task not found")
    
    return {
        "id": task.id,
        "title": task.title,
        "description": task.description,
        "completed": task.completed
    }

# Update Task 
@app.patch("/tasks/{task_id}")
def update_task(task_id: int, updated_task: TaskCreate, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == task_id).first()

    if task is None:
        raise HTTPException(status_code=404, detail="Task not found")
    
    task.title = updated_task.title
    task.description = updated_task.description

    db.commit()
    db.refresh(task)

    return {
        "id": task.id,
        "title": task.title,
        "description": task.description,
        "completed": task.completed
    }

# Delete Task 
@app.delete("/tasks/{task_id}")
def delete_task(task_id: int, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == task_id).first()

    if task is None:
        raise HTTPException(status_code=404, detail="Task not found")

    db.delete(task)
    db.commit()

    return {"message": "Task deleted"}