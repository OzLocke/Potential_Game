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
        
    class Spaces():
        def __init__(self, q, r):
            self.q = q
            self.r = r
            self.piece = None


    def __init__(self, board_size = 7):
        self.players = []
        self.board_size = board_size
        self.board = []
        
        #Create the players, store them in an array so they don't need to be assigned to variables
        for n in range(2):
            self.players.append(self.Players(n))
        
        #Map the board
        #First column number of top row
        start_col = math.floor(self.board_size/2)
        #Number of columns in first row
        cols = math.ceil(self.board_size/2)
        #Row number of middle row
        midway = math.ceil(self.board_size/2) - 1
        #Empty array to hold board
        
        #Create each row
        for r in range(self.board_size):
            #Create each column (q) in the row, appending each to the board
            for q in range(start_col, start_col + cols):
                #Board contains written address, object, and piece if needed
                self.board.append(["{0},{1}".format(q,r),self.Spaces(q,r),None])
            #Decrement starting column number (min 0)
            if start_col > 0:
                start_col -= 1
            #Decrement or increment row number based on whether above or bellow midway
            if r < midway:
                cols += 1
            else:
                cols -= 1

        #Populate the board with pieces
        #Find last row
        bottom_row = 0
        for e in self.board:
            row = e[1].r
            if row > bottom_row:
                bottom_row = row
        #Loop over the players so we can assign their objects as owners
        for p in self.players:
            piece = 0
            first_row = 0
            second_row = 1
            if p.name == "player1":
                first_row = bottom_row
                second_row = bottom_row - 1
            #Loop over the board array
            for e in self.board:
                #Add pieces to the board in every space of the first row, and every odd space of the second row
                if e[1].r == first_row or (e[1].r == second_row and e[1].q % 2 != 0):
                    e[2] = self.Pieces(piece,p)
                    piece += 1

    def view_board(self):
        #Prints a list of all spaces on the board, and pieces on those spaces where they exist
        for e in self.board:
            if e[2] is None:
                print("{0} | empty".format(e[0]))
            else:
                print("{0} | {1} (Charge: {2}, Owner: {3})".format(e[0],e[2].name,str(e[2].charge),e[2].owner.name))



#--Generate a table (creates players, sets up a board, populates it with pieces--#
table = Table()

#Take a look at the board
table.view_board()