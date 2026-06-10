from fastapi import FastAPI

app = FastAPI(title="Cloud Task Manager")

tasks = []

@app.get("/")
def health_check():
    return {"status": "ok", "service": "cloud-task-manager"}

@app.get("/tasks")
def get_tasks():
    return {"tasks": tasks}

@app.post("/tasks")
def create_task(task:dict):
    tasks.append(tasks)
    return {"message":"task created", "task": task}