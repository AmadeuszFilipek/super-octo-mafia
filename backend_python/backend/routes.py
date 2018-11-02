from flask import request
from flask import send_from_directory
from backend_python.backend.game import Game, WrongStateException
from backend_python import app, app_state
from backend_python.backend.town import VoteException

def find_game(slug):
    try:
        return app_state[slug]
    except KeyError:
        return None



@app.route('/')
@app.route('/towns/<path>')
def endpoint_index(path = None):
    return send_from_directory('../frontend/', 'index.html')



@app.route('/api/towns', methods=['POST'])
def endpoint_create_game():
    game = find_game(request.json['town']['slug'])

    if not game:
        game = Game(request.json['town']['slug'])
        game.add_player(request.json['player']['name'], True)

        app.logger.info('new town = ' + str(game.jversonify()))
        print('New town = ' + str(game.jversonify()))

    app_state[request.json['town']['slug']] = game
    return game.jversonify()



# debug purposes
@app.route('/api/towns/<slug>')
def endpoint_show_game(slug):
    game = find_game(slug)

    if game is None:
        raise GameDoesNotExistException

    game.next_state_maybe()

    return game.jversonify()



# debug purposes
@app.route('/api/towns/<slug>', methods=['DELETE'])
def endpoint_delete_game(slug):
    app_state.pop(slug, None)
    return "{}"



@app.route('/api/towns/<slug>/players', methods=['POST'])
def endpoint_join_game(slug):
    game = find_game(slug)
    player = request.json['player']
    game.add_player(player['name'])

    return game.jversonify()



@app.route('/<path>')
def static_files_handler(path):
    return send_from_directory('../frontend/', path)



@app.route('/api/towns/<slug>/start', methods=['POST'])
def endpoint_start_game(slug):
    game = find_game(slug)
    game.start_game(request.json)

    return game.jversonify()



@app.route('/api/towns/<slug>/votes', methods=['POST'])
def endpoint_vote(slug):
    game = find_game(slug)
    
    vote = request.json['vote']
    try:
        game.vote(vote['voterName'], vote['voteeName'])
        return game.jversonify()
    except (VoteException, WrongStateException):
        return game.jversonify(), 422


class GameDoesNotExistException(Exception): pass
