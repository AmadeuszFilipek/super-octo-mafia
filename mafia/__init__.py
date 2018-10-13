from flask import Flask
app = Flask(__name__)
app_state = {}

import mafia.backend.routes
