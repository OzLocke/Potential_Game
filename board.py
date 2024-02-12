# Import math library
import math

class Table():
    def __init__(self, player_count = 2, board_size = 7):
        self.player_count = player_count
        self.board_size = board_size
        
        #Create the board
        self.board = self.Board(board_size)

        #Create the players assigning them to dynamic variables via a dictionary
        self.players = {}
        for n in range(player_count):
            #Define player name (e.g. player1)
            player = "player{0}".format(n)
            #Add a variable to players and assign an instance of Players
            self.players[player] = self.Players(player, self.board.size - 1)

    class Players():
        def __init__(self, player, piece_count):
            self.player = player
            self.piece_count = piece_count
            #Create pieces assigned to the player
            self.pieces = {}
            for n in range(piece_count):
                self.pieces["piece{0}".format(n)] = self.Pieces(self.player)

        class Pieces():
            def __init__(self, charge = 3):
                self.charge = charge

    class Board():
        def __init__(self, size = 7):
            self.size = size
            #Create the board
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

#--Generate a Board--#
player_count = 2
board_size = 7
table = Table(player_count, board_size)

#And look it all over
print(table.players.keys())
print(table.board.board)
print(table.players["player1"].pieces.keys())
