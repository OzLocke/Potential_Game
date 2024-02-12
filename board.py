# Import math library
import math

class Players():
    def __init__(self, number):
        self.number = number

class Board():
    #size = 7 defines a default value for the variable
    def __init__(self, size = 7):
        self.size = size

    def generate_board(self):
        #First column number of top row
        self.start_col = math.floor(self.size/2)
        #Number of columns in first row
        self.cols = math.ceil(self.size/2)
        #Row number of middle row
        self.midway = math.ceil(self.size/2) - 1
        #Empty array to hold board
        self.board = []
        #Create each row
        for r in range(self.size):
            #Create each column (q) in the row, appending each to the board
            for q in range(self.start_col, self.start_col + self.cols):
                self.board.append([q,r])
            #Decrement starting column number (min 0)
            if self.start_col > 0:
                self.start_col -= 1
            #Decrement or increment row number based on whether above or bellow midway
            if r < self.midway:
                self.cols += 1
            else:
                self.cols -= 1

class Pieces():
    def __init__(self, player, charge = 3):
        self.player = player
        self.charge = charge
        
class Table():
    def __init__(self, players, board, pieces):
        self.players = players
        self.board = board
        self.pieces = pieces

#--Generate Players--#
player_count = 2
players = {}
#Loop over number of players, creating an instance for each
#   and assigning them to dynamic variables via a dictionary
for n in range(player_count):
    players["player{0}".format(n)] = Players(n)

#--Generate a Board--#
board = Board()
board.generate_board()

#--Generate Pieces--#
pieces = {}
#Loop over players, creating instances of pieces for each
#   equal to the board size and assigning them to dynamic variables via a dictionary
for player in players.keys():
    for n in range(board.size):
        pieces["{0}_piece{1}".format(player, n)] = Pieces(player)

#--Put Everything on the Table!--#
table = Table(players, board, pieces)

print(table.players.keys())
print(table.board.board)
print(table.pieces.keys())
