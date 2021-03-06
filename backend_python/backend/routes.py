from flask import request, send_from_directory, jsonify, Flask
from backend.game import Game, GameException
from backend.town import TownException

app = Flask(__name__)
app_state = {}

def find_game(slug):
    try:
        return app_state[slug]
    except KeyError:
        raise GameDoesNotExistException



@app.route('/')
@app.route('/towns/<path>')
def endpoint_index(path = None):
    return send_from_directory('../../frontend/', 'index.html')



@app.route('/api/towns', methods=['POST'])
def endpoint_create_game():
    try:
        game = find_game(request.json['town']['slug'])
        raise GameAlreadyExistException

    except GameDoesNotExistException:
        game = Game(request.json['town']['slug'])
        game.add_player(request.json['player']['name'], True)

    app_state[request.json['town']['slug']] = game
    return game.jversonify()



# debug purposes
@app.route('/api/towns/<slug>')
def endpoint_show_game(slug):
    game = find_game(slug)

    return game.jversonify()



@app.route('/api/towns/<slug>/progress', methods=['PUT'])
def endpoint_progress(slug):
    game = find_game(slug)
    game.progress()

    return game.jversonify()


@app.route('/api/towns/<slug>/restart', methods=['PUT'])
def endpoint_restart(slug):
    game = find_game(slug)
    game.restart()

    return game.jversonify()


# debug purposes
@app.route('/api/towns/<slug>', methods=['DELETE'])
def endpoint_delete_game(slug):
    app_state.pop(slug, None)
    return jsonify({})


@app.route('/api/towns/<slug>/players', methods=['POST'])
def endpoint_join_game(slug):
    game = find_game(slug)
    player = request.json['player']
    game.add_player(player['name'])

    return game.jversonify()



@app.route('/<path>')
def static_files_handler(path):
    return send_from_directory('../../frontend/', path)



@app.route('/api/towns/<slug>/start', methods=['POST'])
def endpoint_start_game(slug):
    game = find_game(slug)
    game.start_game(request.json)

    return game.jversonify()



@app.route('/api/towns/<slug>/votes', methods=['POST'])
def endpoint_vote(slug):
    game = find_game(slug)

    vote = request.json['vote']
    game.vote(vote['voterName'], vote['voteeName'])

    return game.jversonify()

class RoutesException(Exception): pass
class GameDoesNotExistException(RoutesException): pass
class GameAlreadyExistException(RoutesException): pass

@app.errorhandler(TownException)
@app.errorhandler(GameException)
@app.errorhandler(RoutesException)
def exception_handler(error):
    return jsonify({'error': error.__class__.__name__}), 422

