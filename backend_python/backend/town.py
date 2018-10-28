try:
    from backend_python.backend.player import Player
except ModuleNotFoundError:
    from player import Player

from datetime import datetime
from random import sample, choice
from math import floor, ceil
import code

class Town(object):

    def __init__(self, slug):

        self.slug = slug
        self.players = {}
        self.votes = {}
        self.is_ready_to_start = False


    def to_dict(self):
        dictionary = self.__dict__.copy()
        dictionary['players'] = {}
    
        for player in self.players.keys():
            dictionary['players'][player] = self.players[player].to_dict()

        return dictionary


    def add_player(self, name, is_host = False):
        self.players[name] = Player(name, is_host)
        self.check_ready_to_start()


    def vote(self, voterName, voteeName):
        if voterName not in self.players:
            raise NonExistingVoterException
        if voteeName not in self.players:
            raise NonExistingVoteeException
        if not self.players[voterName].is_alive:
            raise DeadVoterException
        if not self.players[voteeName].is_alive:
            raise DeadVoteeException

        self.votes[voterName] = voteeName


    def check_ready_to_start(self):
        self.is_ready_to_start = len(self.players.keys()) >= 5
        return self.is_ready_to_start


    def assign_characters(self, backdoor_players = None):

        for player in self.players.values():
            if backdoor_players and player.name in backdoor_players.keys():

                player.set_character(backdoor_players[player.name])

            else:
                number_of_mafia = floor(len(self.players.keys()) * 0.25)

                for player in sample(self.players.values(), number_of_mafia):
                    player.set_character('mafia')


    def execute_vote(self, *args, **kwargs):
        player_to_die = self.resolve_vote()
        player_to_die.kill()
        self.status['killed_player'] = player_to_die.name


    def resolve_vote(self):
        # if len(self.votes.keys() == 0) return None
    
        vote_counts = dict.fromkeys(self.votes.values(), 0)
        for voteeName in self.votes.values(): vote_counts[voteeName] += 1
            
        voteeWithMaxVotes = None
        maxVotes = 0
        
        for voteeName, voteCounts in vote_counts.items():
            if voteCounts >= maxVotes:
                voteeWithMaxVotes = voteeName
                maxVotes = voteCounts

        return self.players[voteeWithMaxVotes]


    def is_vote_finished(self, *args, **kwargs):
        return len(self.votes) == len(self.players) and len(self.players) > 0


    def clear_vote_pool(self):
        self.votes = {}


    def get_winner(self):

        alive_mafia = 0
        alive_civils = 0

        for player in self.players.values():
            if player.is_alive:
                if player.character == 'mafia':
                    alive_mafia += 1
                else:
                    alive_civils += 1

        winner = None

        if alive_mafia == 0:
            winner = 'civils'
        elif alive_civils < alive_mafia:
            winner = 'mafia'
        elif alive_mafia == 1 and alive_mafia == alive_civils:
            winner = 'mafia'

        return winner


class TownDoesNotExistException(Exception): pass

class NonExistingVoterException(Exception): pass

class NonExistingVoteeException(Exception): pass

class DeadVoterException(Exception): pass

class DeadVoteeException(Exception): pass


