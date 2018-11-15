from backend.game import Game

game = Game('Swiebodzin')

game.add_player('sasanka')
game.add_player('kaktus')
game.add_player('boletz')
game.add_player('pizdziec')
game.add_player('pusi_crussher')

game.start_game()

mafioso_number = len([p for p in game.town.players.values() if p.character == 'mafia'])

assert mafioso_number == 1, 'Game with five players should start with 1 mafioso character, not {0}.'.format(mafioso_number)