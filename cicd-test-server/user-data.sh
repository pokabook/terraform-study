#!/bin/bash

python3 -m venv venv

. venv/bin/activate

pip install Flask

cat > hello.py <<EOF
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
EOF

flask --app hello run --host 0.0.0.0
