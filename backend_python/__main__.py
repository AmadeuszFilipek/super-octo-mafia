from os import environ as env
from backend.routes import app

HOST = env.get('FLASK_HOST', '0.0.0.0')
PORT = env.get('FLASK_PORT', '5000')
DEBUG = True
OPTIONS = {
    'env': 'development',
    'use_reloader': True
}

app.run(HOST, PORT, DEBUG, OPTIONS)
