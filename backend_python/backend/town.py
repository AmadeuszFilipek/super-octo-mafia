from backend_python.backend.player import Player
from flask import jsonify
from datetime import datetime

class Town(object):

	def __init__(self, slug):
		self.slug = slug
		self.players = {}
		self.votes = {}
		self.state = {'id': 'waiting_for_players'}
		self.started_at = datetime.now().timestamp()


	def to_dict(self):
		dictionary = self.__dict__.copy()
		dictionary['players'] = {}

		for player in self.players.keys():
			dictionary['players'][player] = self.players[player].to_dict()

		return dictionary


	def add_player(self, name, is_host = False):
		self.players[name] = Player(name, is_host)


	def start_game(self, backdoor_players = None):
		for player in self.players.values():
			if backdoor_players and player.name in backdoor_players.keys():
				player.character = backdoor_players[player.name]
			else:
				player.generate_character()



		self.state['id'] = 'day_voting'
	
		



	def vote(self, vote):
		self.votes[vote['voterName']] = vote['voteeName']


	def execute_vote(self):
		vote_counts = {}
		for player in self.players.values():
			vote_counts[sum(
				[vote for vote in self.votes.values() if vote == player.name])] \
				= player.name

		player_to_die = vote_counts[max(vote_counts.keys())]
		player_to_die.kill()

		self.state = {'id': 'night_voting'}


	def jversonify(self):
		self.version = datetime.now().timestamp()

		return(jsonify(self.to_dict()))


	def check_if_game_ended(self):
		raise NotImplementedError
		
		alive_mafia = 0
		alive_civils = 0
		
		for player in self.players.values():
			if player.is_alive:
				if player.character == 'mafia':
					alive_mafia += 1
				else:
					allive_civils += 1
		
		is_game_ended = False
		
		if alive_mafia == 0:
			is_game_ended = True
			game_won = 'civils'
		elif alive_civils < alive_mafia:
			is_game_ended = True
			game_won = 'mafia'
		elif alive_mafia == 1 and alive_mafia == alive_civils:
			is_game_ended = True
			game_won = 'mafia' 		

		if is_game_ended:
			self.state = {'id': 'game_ended'}
		
		return game_won

class TownDoesNotExistException(Exception):
	pass





