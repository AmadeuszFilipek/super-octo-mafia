try:
    from backend_python.backend.player import Player
except ModuleNotFoundError:
    from player import Player

from flask import jsonify
from datetime import datetime
from random import sample, choice
from math import floor, ceil
from transitions import Machine, State

import logging
logging.basicConfig(filename='state_machine.log', level=logging.DEBUG)
logging.getLogger('transitions').setLevel(logging.DEBUG)

class Town(object):

    states = ['waiting_for_players', 'day_voting', 'day_results',
           'night_voting', 'night_results', 'game_ended']

    timed_states = ['day_voting', 'day_results', 'night_voting', 'night_results']

    initial_state = 'waiting_for_players'

    on_enter_hooks = {'*': 'stamp_state'}

    on_exit_hooks = {'day_voting': 'clear_vote_pool',
        'night_voting': 'clear_vote_pool',
        'day_results': 'clear_results',
        'night_results': 'clear_results'
        }

    # name, source, destination
    transitions = [
        ['t_start_game', 'waiting_for_players', 'day_voting'],

        ['t_execute_vote', 'day_voting', 'day_results'],
        ['t_execute_vote', 'night_voting', 'night_results'],

        ['t_progress', 'day_voting', 'day_results'],
        ['t_progress', 'night_voting', 'night_results'],
        ['t_progress', 'day_results', 'night_voting'],
        ['t_progress', 'night_results', 'day_voting'],

        ['t_end_game', ['day_voting', 'day_results', 'night_voting', 'night_results'], 'game_ended']
    ]

    conditions = {'t_start_game': 'check_ready_to_start'}

    unless_conditions = {'t_progress': 'is_game_ended'}


    def __init__(self, slug):

        self.game = Machine(model=self,
            states=self.generate_states(),
            transitions=self.generate_transitions(),
            initial=Town.initial_state)

        self.status = {'id': Town.initial_state}
        self.state_live_time = 5

        self.slug = slug
        self.players = {}
        self.votes = {}
        self.is_ready_to_start = False


    def generate_states(self):

        hooked_states = []
        for state in Town.states:

            on_enters = []
            on_exits = []

            if state in Town.on_enter_hooks:
                on_enters.append(Town.on_enter_hooks[state])
            if state in Town.on_exit_hooks:
                on_exits.append(Town.on_exit_hooks[state])

            if '*' in Town.on_enter_hooks:
                on_enters.append(Town.on_enter_hooks['*'])
            if '*' in Town.on_exit_hooks:
                on_exits.append(Town.on_enter_hooks['*'])

            hooked_states.append(State(name=state, on_enter=on_enters, on_exit=on_exits))

        return hooked_states


    def generate_transitions(self):

        hooked_transitions = []
        for trans_name, trans_sources, trans_dest in Town.transitions:

            conditions = []
            unlesses = []
            if trans_name in Town.conditions:
                conditions.append(Town.conditions[trans_name])
            if trans_name in Town.unless_conditions:
                unlesses.append(Town.unless_conditions[trans_name])
            if '*' in Town.conditions:
                conditions.append(Town.conditions['*'])
            if '*' in Town.unless_conditions:
                unlesses.append(Town.unless_conditions['*'])

            hooked_transitions.append({
                'trigger': trans_name,
                'source': trans_sources,
                'dest': trans_dest,
                'conditions': conditions,
                'unless': unlesses
            })

        return hooked_transitions


    def to_dict(self):
        dictionary = self.__dict__.copy()

        # rip all the unseriazable objects
        respected_types = (int, float, str, list, dict, tuple)
        keys_to_remove = []
        for key in dictionary.keys():
            if not(isinstance(dictionary[key], respected_types) or dictionary[key] is None):
                keys_to_remove.append(key)

        for key in keys_to_remove:
            dictionary.pop(key)

        dictionary['players'] = {}
        self.status['id'] = self.state
        dictionary['state'] = self.status
        dictionary.pop('status')

        for player in self.players.keys():
            dictionary['players'][player] = self.players[player].to_dict()

        return dictionary


    def jversonify(self):
        self.version = datetime.now().timestamp()

        return(jsonify(self.to_dict()))


    def add_player(self, name, is_host = False):
        self.players[name] = Player(name, is_host)
        self.check_ready_to_start()


    def vote(self, vote):
        self.votes[vote['voterName']] = vote['voteeName']


    def stamp_state(self, *args, **kwargs):
        self.status['started_at'] = datetime.now().timestamp()
        self.status['id'] = self.state


    def check_ready_to_start(self, *args, **kwargs):
        self.is_ready_to_start = len(self.players.keys()) >= 5
        return self.is_ready_to_start


    def start_game(self, backdoor_players = None):
        self.t_start_game()

        for player in self.players.values():
            if backdoor_players and player.name in backdoor_players.keys():

                player.set_character(backdoor_players[player.name])

            else:
                number_of_mafia = floor(len(self.players.keys()) * 0.25)

                for player in sample(self.players.values(), number_of_mafia):
                    player.set_character('mafia')


    def execute_vote(self, *args, **kwargs):
        self.t_execute_vote()

        player_to_die = self.resolve_vote()
        player_to_die.kill()
        self.status['killed_player'] = player_to_die.name


    def resolve_vote(self, *args, **kwargs):

        vote_counts = []
        player_names = []

        for player in self.votes.keys():

            vote_count = sum([vote for vote in self.votes.values() if vote == player.name])
            vote_counts.append(vote_count)

        max_votes = max(vote_counts)
        potential_targets = []

        # build potential target list
        while len(vote_counts.count(max_votes)) > 0:
            index = vote_counts.index(max_votes)
            potential_targets.append(player_names[index])
            vote_counts.pop(index)
            player_names.pop(index)

        killed_player_name = choice(potential_targets)
        player_to_die = self.players[killed_player_name]

        return player_to_die


    def is_vote_finished(self, *args, **kwargs):
        return len(self.votes.keys()) == len(self.players.keys()) and len(self.players.keys() > 0)


    def clear_vote_pool(self,*args, **kwargs):
        self.votes = {}


    def clear_results(self, *args, **kwargs):
        self.status['killed_player'] = None


    def get_winner(self):

        alive_mafia = 0
        alive_civils = 0

        for player in self.players.values():
            if player.is_alive:
                if player.character == 'mafia':
                    alive_mafia += 1
                else:
                    allive_civils += 1

        winner = None

        if alive_mafia == 0:
            winner = 'civils'
        elif alive_civils < alive_mafia:
            winner = 'mafia'
        elif alive_mafia == 1 and alive_mafia == alive_civils:
            winner = 'mafia'

        return winner


    def is_game_ended(self, *args, **kwargs):

        winner = self.get_winner()

        if winner:
            self.status['winner'] = winner
            self.end_game()

        return (winner is not None)


    def is_state_outdated(self):
        return self.status['started_at'] + self.state_live_time < self.version


    def next_state_maybe(self):
        # debug this, somehow it triggers in waiting_for_players
        if self.state in self.timed_states and \
            (self.is_state_outdated or self.is_vote_finished()):
            self.progress()


class TownDoesNotExistException(Exception):
    pass





