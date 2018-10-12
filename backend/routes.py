from flask import Flask
from flask import jsonify
from flask import request
from flask import send_from_directory
from .town import *
from datetime import datetime

app = Flask(__name__)



@app.route('/')
@app.route('/towns/<path>')
def endpoint_index(path = None):
	return send_from_directory('../frontend/', 'index.html')



@app.route('/api/towns', methods = ['POST'])
def endpoint_create_town():
	town = find_town(request.json['town']['slug'])

	if not town:
		town = create_town(request.json['town'])
		app.logger.info('new town = ' + str(jsonify(town)));
		add_player(town, request.json['player'], True)

		print('town = ' + str(jsonify(town)));
	return jversonify(town)



@app.route('/api/towns/<slug>')
def endpoint_show_town(slug):
	town = find_town(slug)

	if town is None:
		raise Exception
	return jversonify(town)


# needed for curl tests, to not restart server every test
@app.route('/api/towns/<slug>', methods = ['DELETE'])
def endpoint_delete_town(slug):
    delete_town(slug)
    return ""




@app.route('/api/towns/<slug>/players', methods = ['POST'])
def endpoint_join_town(slug):
	town = find_town(slug)
	player = request.json['player']

	add_player(town, player)

	return jversonify(town)



@app.route('/<path>')
def static_files_handler(path):
	return send_from_directory('../frontend/', path)


@app.route('/api/towns/<slug>/start', methods = ['POST'])
def endpoint_start_game(slug):
	town = find_town(slug)

	start_game(town)

	return jversonify(town)

@app.route('/api/towns/<slug>/votes', methods = ['POST'])
def endpoint_vote(slug):
	town = find_town(slug)

	vote(town, request.json['vote'])

	return jversonify(town)

def jversonify(town):
	town['version'] = datetime.now().timestamp()

	return jsonify(town)


