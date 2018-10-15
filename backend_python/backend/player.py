import random

class Player(object):

    CHARACTERS = ['mafia', 'civil']

    def __init__(self, name, is_host = False):
        self.name = name
        self.is_host = is_host
        self.is_alive = True

    def to_dict(self):
        return self.__dict__

    def generate_character(self):
        self.character = random.choice(self.CHARACTERS)

    def kill(self):
        self.is_alive = False
