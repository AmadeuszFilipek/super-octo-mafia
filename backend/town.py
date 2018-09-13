from uuid import uuid4

app_state = {}

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
	player_name = player_data['name']
	town['players'][player_name] = player_data.copy()






