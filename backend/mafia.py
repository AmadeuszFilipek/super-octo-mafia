from flask import Flask
from flask import jsonify
from flask import request
from uuid import uuid4
app = Flask(__name__)

app_state = {}

@app.route('/towns', methods = ['POST'])
def request_create_town():

	# jak tworzymy pokoj to chcemy go dolozyc do tablicy pokoi
	town = find_town(request.json['town']['slug'])
	
	print('ziemniak')
	
	if not town:
		town = create_town(request.json['town'])
		add_player(town, request.json['player'])
		
	return jsonify(town)
	
# debug purposes	
@app.route('/towns/<slug>')
def show_town(slug):
	town = find_town(slug)
	return jsonify(town)

def find_town(slug):
	try:
		return app_state[slug]
	except KeyError:
		return None

def create_town(town_data):
	app_state[town_data['slug']] = town_data.copy()
	
	app_state[town_data['slug']]['players'] = {}
	app_state[town_data['slug']]['state'] = {'id': 'waiting_for_players'}
	
	return app_state[town_data['slug']]
	
def add_player(town, player_data):
	new_id = str(uuid4())
	town['players'][new_id] = player_data.copy()
	town['players'][new_id]['id'] = new_id

	
	
	
	
	