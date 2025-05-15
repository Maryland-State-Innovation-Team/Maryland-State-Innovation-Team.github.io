# all_occupation_task_ratings.csv

This file contains AI-generated ratings of the exposure of specific occupational tasks to AI automation. Each row represents a single task associated with an occupation, along with a rating indicating the degree to which AI can perform that task.

**Columns:**
- `occupation_title`: The name of the occupation (string).
- `task`: A specific task performed within the occupation (string).
- `rating`: An integer from 1 to 5 representing the task's exposure to AI automation:
    - 1: AI cannot perform the task at all
    - 2: AI can perform the task with assistance from a human operator
    - 3: AI can perform the task as well as an average human
    - 4: AI can perform the task as well as an expert human
    - 5: AI can perform the task better than an expert human

**Source:**  
Ratings are generated using large language models (Google Gemini or OpenAI GPT) via the [MD-Workforce-AI-Impacts](https://github.com/Maryland-State-Innovation-Team/MD-Workforce-AI-Impacts) codebase. See `python/rate_tasks.py` for details on the rating methodology and prompt.

**Related files:**
- `all_occupation_tasks.csv`: The input file listing all occupation-task pairs to be rated.
