try:
    from backend_python.backend.town import Town
except ModuleNotFoundError:
    from town import Town

import code
import logging
from datetime import datetime

from flask import jsonify
from transitions import Machine, State, Transition

logging.basicConfig(filename='state_machine.log', level=logging.DEBUG)
logging.getLogger('transitions').setLevel(logging.DEBUG)


class Game(object):
    
    initial_state = 'waiting_for_players'
    timed_states = ['day_voting', 'day_results', 'night_voting', 'night_results']
    voting_states = ['day_voting', 'night_voting']

    def __init__(self, slug, options={}):
        self.town = Town(slug)
        self.status = {}
        self.version = datetime.now().timestamp()

        self.machine = Machine(model=self,
            states=self.generate_states(),
            transitions=self.generate_transitions(),
            initial=Game.initial_state)

    def generate_states(self):
        states = []
        states.append(State('waiting_for_players', on_enter=self.stamp_state))

        states.append(State('day_voting', 
            on_enter=[self.stamp_state, self.clear_results],
            on_exit=self.execute_vote))

        states.append(State('day_results',
            on_enter=self.stamp_state))

        states.append(State('night_voting', 
            on_enter=[self.stamp_state, self.clear_results],
            on_exit=self.execute_vote))

        states.append(State('night_results',
            on_enter=self.stamp_state))
            
        states.append(State('game_ended', 
            on_enter=[self.stamp_state, self.set_winner]))
                
        return states

    def generate_transitions(self):
        transitions = []
        transitions.append({
                'trigger': 't_start_game',
                'source': 'waiting_for_players',
                'dest': 'day_voting',
                'conditions': self.town.check_ready_to_start,
            })
        transitions.append({
                'trigger': 't_execute_vote',
                'source': 'day_voting',
                'dest': 'day_results',
                'conditions': None,
                'after': self.end_game_maybe,
            })
        transitions.append({
                'trigger': 't_progress',
                'source': 'day_results',
                'dest': 'night_voting',
                'conditions': self.can_progress,
                'before': self.clear_vote_pool,
            })
        transitions.append({
                'trigger': 't_execute_vote',
                'source': 'night_voting',
                'dest': 'night_results',
                'conditions': None,
                'after': self.end_game_maybe, 
            })
        transitions.append({
                'trigger': 't_progress',
                'source': 'night_results',
                'dest': 'day_voting',
                'conditions': self.can_progress,
                'before': self.clear_vote_pool,
            })
        transitions.append({
                'trigger': 't_end_game',
                'source': ['day_results', 'night_results'],
                'dest': 'game_ended',
                'before': self.end_game
            })
        
        return transitions


    def to_dict(self):
        dictionary = self.town.to_dict()
        self.status['id'] = self.state
        dictionary['state'] = self.status
        dictionary['version'] = self.version

        return dictionary

    def jversonify(self):
        self.version = datetime.now().timestamp()

        return(jsonify(self.to_dict()))


    def start_game(self, *args):
        self.t_start_game()
        self.town.assign_characters(*args)

    def execute_vote(self, *args, **kwargs):
        self.status['killed_player'] = self.town.execute_vote()

    def clear_vote_pool(self, *args, **kwargs):
        self.town.clear_vote_pool()

    def end_game(self, *args, **kwargs):
        pass    

    def vote(self, voterName, voteeName):
        if self.state not in Game.voting_states:
            raise NotInVotingStateException

        is_night_vote = (self.state == 'night_voting')
        self.town.vote(voterName, voteeName, is_night_vote)     

        if self.town.is_voting_finished(is_night_vote):
            self.t_execute_vote()

    def can_game_continue(self, *args, **kwargs):
        winners = self.town.get_winner()
        return (winners is None)

    def progress(self):
        if self.state in Game.voting_states:
            self.t_execute_vote()
        else:
            self.t_progress()

    def end_game_maybe(self):
        if not self.can_game_continue(): 
            self.t_end_game()


    def stamp_state(self, *args, **kwargs):
        self.status['started_at'] = datetime.now().timestamp()
    
    def clear_results(self, *args, **kwargs):
        self.status.pop('killed_player', None)

    def set_winner(self, *args, **kwargs):
        self.status['winners'] = self.town.get_winner()

    def add_player(self, player, is_host=False):
        if self.state not in Game.initial_state:
            raise NotInWaitingForPlayersStateException
        self.town.add_player(player, is_host)

class WrongStateException(Exception): pass

class NotInWaitingForPlayersStateException(WrongStateException): pass

class NotInVotingStateException(WrongStateException): pass
