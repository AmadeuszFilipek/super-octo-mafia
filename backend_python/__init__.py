from flask import Flask
app = Flask(__name__)
app_state = {}

import backend_python.backend.routes
