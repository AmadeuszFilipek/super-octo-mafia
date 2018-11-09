from backend.player import Player

import code
from datetime import datetime
from math import ceil, floor
from random import choice, sample


class Town(object):

    MAFIA_RATIO = 0.25

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


    def get_player_character(self, name):
        return self.players[name].character


    def vote(self, voter_name, votee_name, is_night_vote=False):
        if voter_name not in self.players:
            raise NonExistingVoterException
        if votee_name not in self.players:
            raise NonExistingVoteeException
        if voter_name == votee_name:
            raise CannotVoteOnSelfException
        if is_night_vote and self.players[voter_name].character != 'mafia':
            raise OnlyMafiaCanVoteAtNightException
        if not self.players[voter_name].is_alive:
            raise DeadVoterException
        if not self.players[votee_name].is_alive:
            raise DeadVoteeException

        self.votes[voter_name] = votee_name


    def check_ready_to_start(self):
        self.is_ready_to_start = len(self.players.keys()) >= 5
        return self.is_ready_to_start


    def assign_characters(self, backdoor_players=None):

        for player in self.players.values():
            if backdoor_players and player.name in backdoor_players.keys():

                player.set_character(backdoor_players[player.name])

            else:
                number_of_mafia = floor(len(self.players.keys()) * self.MAFIA_RATIO)

                for player in sample(self.players.values(), number_of_mafia):
                    player.set_character('mafia')


    def execute_vote(self, *args, **kwargs):
        player_to_die = self.resolve_vote()
        player_to_die.kill()

        return player_to_die.name

    def resolve_vote(self):

        vote_counts = dict.fromkeys(self.votes.values(), 0)
        for voteeName in self.votes.values(): vote_counts[voteeName] += 1

        voteeWithMaxVotes = None
        maxVotes = 0

        for voteeName, voteCounts in vote_counts.items():
            if voteCounts >= maxVotes:
                voteeWithMaxVotes = voteeName
                maxVotes = voteCounts

        if voteeWithMaxVotes is None:
            raise EmptyVotePoolException

        return self.players[voteeWithMaxVotes]


    def is_voting_finished(self, is_night_vote=False):
        if is_night_vote:
            number_of_voters = len([p for p in self.players.values() if p.is_alive and p.character == 'mafia'])
        else:
            number_of_voters = len([p for p in self.players.values() if p.is_alive])

        return len(self.votes) == number_of_voters


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


class VoteException(Exception): pass

class NonExistingVoterException(VoteException): pass

class NonExistingVoteeException(VoteException): pass

class CannotVoteOnSelfException(VoteException): pass

class DeadVoterException(VoteException): pass

class DeadVoteeException(VoteException): pass

class OnlyMafiaCanVoteAtNightException(VoteException): pass

class EmptyVotePoolException(VoteException): pass
