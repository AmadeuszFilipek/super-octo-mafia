from flask import Flask
from flask import jsonify
from flask import request
from flask import send_from_directory
from .town import *

app = Flask(__name__)

@app.route('/')
@app.route('/towns/<path>')
def root(path = None):
	return send_from_directory('../frontend/', 'index.html')

@app.route('/api/towns', methods = ['POST'])
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
@app.route('/api/towns/<slug>')
def show_town(slug):
	town = find_town(slug)

	if town is None:
		raise "Exception"
	return jsonify(town)

@app.route('/api/towns/<slug>/players', methods = ['POST'])
def join_town(slug):
	town = find_town(slug)
	player = request.json['player']

	add_player(town, player)

	return jsonify(town)

@app.route('/<path>')
def send_file(path):
	return send_from_directory('../frontend/', path)

