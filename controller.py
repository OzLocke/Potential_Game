import math
import numpy as np
import model, view

class Tests():
    def displays(self, test):
        match test:
            case "help":
                print("The following display tests are available: board, my_pieces, moves")
            case "board":
                view.display_board(board, board_df)
            case "my_pieces":
                view.display_my_pieces(players_df[0], board_df)
            case "moves":
                piece = board_df[0][2]
                view.display_moves(piece, board_df, players_df[0])
            case _:
                print("That's not a valid test, use \"help\" for a list of tests")
        
    def functions(self, test):
        match test:
            case "help":
                print("The following function tests are available: name_change")
            case "name_change":
                print(players_df[0].name)
                players_df[0].name_player("Stef")
                print(players_df[0].name)
                print("\n")
            case _:
                print("That's not a valid test, use \"help\" for a list of tests")

# Build dataframes
#Set up players
player_count = 2
players_df = []
for i in range(0, player_count):
    players_df.append(model.Player(i))

# Set up the board
board_size = 5
board = model.Board(players_df, board_size)
board_df = board.set_up()

# Run a test!
tests = Tests()
tests.displays("board")
tests.functions("name_change")

view.list_players(players_df)