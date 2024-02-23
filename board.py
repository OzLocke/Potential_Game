# Import math library
import math
import numpy as np

class Player():
    def __init__(self, player):
        self.player = player
        self.name = "player{0}".format(player)
    
    def my_pieces(self):
        #Creates a list of pieces owned by the given player
        #Get the relevant player object from the players array
        me = self
        #Convert the main board array to a numpy array
        numpy_board = np.array(table.board)
        #Get a list of entries from the board array that have pieces
        filter = numpy_board[(numpy_board[:, 2] != None)]
        #Create a list of all pieces using the filtered version of the board
        all_pieces = filter[:,2]
        #Create the list of pieces that have the required owner
        #   AFAIK you can't use the filtering method used above
        #       to filter by values on a stored object
        #   (there's gotta be a better way to do this! 🤦‍♀️)
        pieces = [piece for piece in all_pieces if piece.owner == me]
        print("Hi, {0}. Here are your pieces:\n".format(me.name))
        for piece in pieces:
            location = table.piece_location(piece)
            print("{0} has {1} charge and is at {2},{3}".format(piece.name, piece.charge, location[0], location[1]))
        #Print an empty line
        print("")
    
    def name_player(self, name):
        #Change player name
        #Store the old name (finding the player in the list of players)
        old_name = self.name
        #Change the name stored on the player object
        players[self.player].name = name
        #Store the new name directly from the object (so we can be sure it's worked!)
        new_name = players[self.player].name
        #Confirm the change
        print("Your name has been changed from {0} to {1}\n".format(old_name, new_name))

class Table():
    class Piece():
        def __init__(self, name, owner, charge = 3):
            self.name = "piece{0}".format(name)
            self.owner = owner
            self.charge = charge
        
    class Space():
        def __init__(self, q, r):
            self.q = q
            self.r = r
            self.piece = None

    def __init__(self, board_size = 7):
        self.board_size = board_size
        #Map the board
        #First column number of top row
        start_col = math.floor(board_size/2)
        #Number of columns in first row
        cols = math.ceil(board_size/2)
        #Row number of middle row
        midway = math.ceil(board_size/2) - 1
        #Empty array to hold board
        self.board = []
        #Create each row
        for r in range(board_size):
            #Create each column (q) in the row, appending each to the board
            for q in range(start_col, start_col + cols):
                #Board contains written address, space object, and piece (though that's blank for now)
                self.board.append(["{0},{1}".format(q,r),self.Space(q,r),None])
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
        bottom_row = self.board_size - 1
        # for e in self.board:
        #     row = e[1].r
        #     if row > bottom_row:
        #         bottom_row = row
        #Loop over the players so we can assign their objects as owners
        for p in players:
            piece = 0
            first_row = 0
            second_row = 1
            #Switches from down from the top row to up from the bottom row for player1
            if p.name == "player1":
                first_row = bottom_row
                second_row = bottom_row - 1
            #Loop over the board array
            for e in self.board:
                #Add pieces to the board in every space of the first row, and every odd space of the second row
                if e[1].r == first_row or (e[1].r == second_row and e[1].q % 2 != 0):
                    e[2] = self.Piece(piece,p)
                    piece += 1

    def view_board(self):
        #Prints a list of all spaces on the board, and pieces on those spaces where they exist
        for e in self.board:
            if e[2] is None:
                print("{0} | empty".format(e[0]))
            else:
                print("{0} | {1} (Charge: {2}, Owner: {3})".format(e[0],e[2].name,str(e[2].charge),e[2].owner.name))
        #Add an empty line
        print("")
    
    def piece_location(self, piece):
        #Takes a piece. Checks neighbours and returns a list of empty spaces.
        #Convert board into a numpy array
        df = np.array(self.board)
        #Get the indices of the subarray that contains the piece (col_indices is not used, but the functin requires it exist)
        row_indices, col_indices = np.nonzero(df == piece)
        #Pull the row itself, using ravel to remove excess arrays (e.g. turns [[0,1]] to [0,1])
        subarray_row = np.ravel(df[row_indices])
        #Get piece!
        space = subarray_row[1] 
        #Get neighbours
        r = space.r
        q = space.q
        #Find columns on this row
        cols_on_r = [i[1].q for i in self.board if i[1] != None and i[1].r == r]
        #Find the min and max cols on this row
        first_q = min(cols_on_r)
        last_q = max(cols_on_r)
        #Is the piece on an end column?
        on_left_edge = q == first_q
        on_right_edge = q == last_q
        #Is it on the bottom or top?
        on_top = r == 0
        on_bottom = r == self.board_size - 1
        #From north west, where should we start scanning?
        scan_start = []
        if on_bottom: 
            #scan starts on the row above and one to the left (NW)
            scan_start = [r - 1, q - 1]
        if on_top:
            #scan starts on the row below and one to the right (SE)
            scan_start = [r + 1, q + 1]


        return [space.q, space.r]
    
    def list_players(self):
        print("This table seats the following players:\n")
        names = [p.name for p in players]
        print(", ".join(map(str,names)) + "\n")
        # print(names)

#--Generate a table (creates players, sets up a board, populates it with pieces)--#
players = [Player(0), Player(1)]
table = Table()
# table.list_players()
# players[0].name_player("Zoe")
# players[1].name_player("Stef")
# table.list_players()
# players[0].my_pieces()
# players[1].my_pieces()
# table.view_board()
table.piece_location(table.board[0][1])