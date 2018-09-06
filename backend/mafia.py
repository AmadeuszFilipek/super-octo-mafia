from flask import Flask
from flask import jsonify
from flask import request

app = Flask(__name__)

state = {'town': None}
	
@app.route('/towns', methods = ['POST'])
def create_town():
	state['town'] = request.json['town']
	return jsonify(state)

@app.route('/towns/<slug>')
def show_town(slug):
	return jsonify(slug)
	

