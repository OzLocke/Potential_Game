# Import math library
import math

class Table():


    class Players():
        def __init__(self, player):
            self.name = "player{0}".format(player)

    class Pieces():
        def __init__(self, name, owner, charge = 3):
            self.name = "piece{0}".format(name)
            self.owner = owner
            self.charge = charge

    class Board():
        def __init__(self, table, size = 7):
            self.table = table
            self.size = size
            #Create the board
            #First column number of top row
            self.start_col = math.floor(self.size/2)
            #Number of columns in first row
            self.cols = math.ceil(self.size/2)
            #Row number of middle row
            self.midway = math.ceil(self.size/2) - 1
            #Empty array to hold board
            
            #Create each row
            for r in range(self.size):
                #Create each column (q) in the row, appending each to the board
                for q in range(self.start_col, self.start_col + self.cols):
                    self.table.spaces.append(self.table.Spaces(q,r))
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


    def __init__(self, board_size = 7):
        self.players = []
        self.board_size = board_size
        self.spaces = []
        self.pieces = []
        
        #Create the players, store them in an array so they don't need to be assigned to variables
        for n in range(2):
            self.players.append(self.Players(n))
        
        #Create the board
        self.board = self.Board(self, board_size)

        #Create pieces, store them in an array so they don't need to be assigned to variables
        self.piece_count = self.board_size - 2
        for player in self.players:
            for n in range(self.piece_count):
                self.pieces.append(self.Pieces(n,player))


        #Put player pieces on the board
        #Find width of top row
        #Load pieces into each space
        #Find next row
        #Load pieces into every other row
        #Repeat for bottom row for other player

#--Generate a Board--#
table = Table()

#And look it all over
for p in table.pieces:
    print(p.owner.name + ", " + p.name + ", charge:" + str(p.charge))
for s in table.spaces:
    print(s.name)
