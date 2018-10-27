from flask import request
from flask import send_from_directory
from backend_python.backend.town import Town, TownDoesNotExistException
from backend_python import app, app_state

def find_town(slug):
    try:
        return app_state[slug]
    except KeyError:
        return None



@app.route('/')
@app.route('/towns/<path>')
def endpoint_index(path = None):
    return send_from_directory('../frontend/', 'index.html')



@app.route('/api/towns', methods = ['POST'])
def endpoint_create_town():
    town = find_town(request.json['town']['slug'])

    if not town:
        town = Town(request.json['town']['slug'])
        town.add_player(request.json['player']['name'], True)

        app.logger.info('new town = ' + str(town.jversonify()))
        print('New town = ' + str(town.jversonify()))

    app_state[request.json['town']['slug']] = town
    return town.jversonify()



# debug purposes
@app.route('/api/towns/<slug>')
def endpoint_show_town(slug):
    town = find_town(slug)

    if town is None:
        raise TownDoesNotExistException

    town.next_state_maybe()

    return town.jversonify()



# debug purposes
@app.route('/api/towns/<slug>', methods = ['DELETE'])
def endpoint_delete_town(slug):
    app_state.pop(slug, None)
    return "{}"



@app.route('/api/towns/<slug>/players', methods = ['POST'])
def endpoint_join_town(slug):
    town = find_town(slug)
    player = request.json['player']
    town.add_player(player['name'])

    return town.jversonify()



@app.route('/<path>')
def static_files_handler(path):
    return send_from_directory('../frontend/', path)



@app.route('/api/towns/<slug>/start', methods = ['POST'])
def endpoint_start_game(slug):
    town = find_town(slug)
    town.start_game(request.json)

    return town.jversonify()



@app.route('/api/towns/<slug>/votes', methods = ['POST'])
def endpoint_vote(slug):
    town = find_town(slug)

    town.vote(request.json['vote'])

    return town.jversonify()
