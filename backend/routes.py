from flask import Flask
from flask import jsonify
from flask import request
from flask import send_from_directory
from .town import *

app = Flask(__name__)

@app.route('/')
def root():
	return send_from_directory('../frontend/', 'index.html')

@app.route('/towns', methods = ['POST'])
def request_create_town():

	# jak tworzymy pokoj to chcemy go dolozyc do tablicy pokoi
	town = find_town(request.json['town']['slug'])

	if not town:
		town = create_town(request.json['town'])
		app.logger.info('new town = ' + str(jsonify(town)));
		add_player(town, request.json['player'])

		print('town = ' + str(jsonify(town)));
	return jsonify(town)

# debug purposes
@app.route('/towns/<slug>')
def show_town(slug):
	town = find_town(slug)
	return jsonify(town)

@app.route('/<path>')
def send_file(path):
	return send_from_directory('../frontend/', path)

