# Import math library
import math

class Table():
    def __init__(self, board_size = 7):
        self.board_size = board_size
        
        #Create the board
        self.board = self.Board(board_size)

        #Create the players assigning them to dynamic variables via a dictionary
        self.players = []
        for n in range(2):
            self.players.append(self.Players(n, self.board.size - 2))

        #Put player pieces on the board
        #Find width of top row
        #Load pieces into each space
        #Find next row
        #Load pieces into every other row
        #Repeat for bottom row for other player

    class Players():
        def __init__(self, player, piece_count):
            self.name = "player{0}".format(player)
            self.piece_count = piece_count
            #Create pieces assigned to the player, assigning them to dynamic variables via a dictionary
            self.pieces = []
            for n in range(piece_count):
                self.pieces.append(self.Pieces(n))

        class Pieces():
            def __init__(self, name, charge = 3):
                self.name = "piece{0}".format(name)
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
            self.spaces = []
            #Create each row
            for r in range(self.size):
                #Create each column (q) in the row, appending each to the board
                for q in range(self.start_col, self.start_col + self.cols):
                    self.spaces.append(self.Spaces(q,r))
                #Decrement starting column number (min 0)
                if self.start_col > 0:
                    self.start_col -= 1
                #Decrement or increment row number based on whether above or bellow midway
                if r < self.midway:
                    self.cols += 1
                else:
                    self.cols -= 1
        
        class Spaces():
            def __init__(self, col, row):
                self.col = col
                self.row = row
                self.piece = None
                self.name = "{0},{1}".format(col,row)

#--Generate a Board--#
table = Table()

#And look it all over
for player in table.players:
    print(player.name)
    for piece in player.pieces:
        print(" " + piece.name)
        print("  Charge: " + str(piece.charge))
# for obj in table.board.spaces:
#     print(obj.name)
# print(table.players["player0"].pieces["piece0"].charge)
