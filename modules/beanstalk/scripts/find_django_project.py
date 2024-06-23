#!/usr/bin/env python3
import sys
import json
import subprocess

repo_owner = sys.argv[1]
repo_name = sys.argv[2]
branch_name = sys.argv[3]

api_url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/git/trees/{branch_name}?recursive=1"

result = subprocess.run(["curl", "-s", api_url], capture_output=True, text=True)
data = json.loads(result.stdout)

project_name = None
for item in data['tree']:
    if item['path'].endswith('settings.py'):
        project_name = item['path'].split('/')[0]
        break

print(json.dumps({"project_name": project_name}))
