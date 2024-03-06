import math
import numpy as np

class Player():
    def __init__(self, player):
        self.player = player
        self.name = "player{0}".format(player)
        
    def my_pieces(self, board_df):
        #Creates a list of pieces owned by the given player
        #Get the relevant player object from the players array
        me = self
        #Convert the main board array to a numpy array
        numpy_board = np.array(board_df)
        #Get a list of entries from the board array that have pieces
        filter = numpy_board[(numpy_board[:, 2] != None)]
        #Create a list of all pieces using the filtered version of the board
        all_pieces = filter[:,2]
        #Create the list of pieces that have the required owner
        #   AFAIK you can't use the filtering method used above
        #       to filter by values on a stored object
        #   (there's gotta be a better way to do this! 🤦‍♀️)
        pieces = [piece for piece in all_pieces if piece.owner == me]
        piece_list = []
        for piece in pieces:
            location = search(board_df, 2, piece)
            piece_list.append([piece, location[1]])
        return(piece_list)
    
    def name_player(self, new_name):
        #Change player name
        old_name = self.name
        self.name = new_name
        return(old_name, new_name)

class Piece():
    def __init__(self, name, owner, charge = 3):
        self.name = "piece{0}".format(name)
        self.owner = owner
        self.charge = charge
        self.moves = self.charge

    def available_moves(self, board_df):
        piece = self
        #Takes a piece. Checks neighbours and returns a list of empty spaces.
        subarray_row = search(board_df, 2, piece)
        #Get the space and the piece that has been selected
        space = subarray_row[1]
        piece = subarray_row[2]
        piece_info = {"Piece": piece, "Space": space}
        #Prepare storage for available moves
        moves = []
        #What changes need to be made to the space reference to check neighbours?
        #[[NW],[NE],[W],[E],[SW],[SE]]
        scan = [[0,-1],[+1,-1],[-1,0],[+1,0],[-1,+1],[0,+1]]
        #Run through the scan array checking the spaces
        for test in scan:
            #Create the target space reference
            target = [space.q + test[0],space.r + test[1]]
            #Get the space from the board
            target_space = search(board_df, 0, "{0},{1}".format(target[0],target[1]))
            available = []
            #If the selected test space exists...
            if target_space.size:
                #First store the space
                available = [target_space, []]
                #Then if it had a piece in it...
                if target_space[2] != None:
                    #Create the new target space reference
                    new_target = [target[0] + test[0],target[1] + test[1]]
                    #Get the space from the board
                    new_target_space = search(board_df, 0, "{0},{1}".format(new_target[0],new_target[1]))
                    #If the selected test space exists...
                    if new_target_space.size:
                        available = [target_space, new_target_space]
                #And finally add it all the the moves list
                moves.append(available)
        #Loop over the moves, writing them out
        #moves = {target: space object, jump: bool, no_jump_reason: str, jumped_piece: piece object}
        move_list = []
        for move in moves:
            target = move[0][1]
            free = move[0][2] == None
            no_jump_reason = ""
            jumped_piece = None
            if not free:
                #If this passes, there's a valid space at the next location
                if len(move[1]) > 0:
                    jumped_piece = move[0][2]
                    #If there's no piece there, it's a valid move
                    if move[1][2] == None:
                        free = True
                        target = move[1][1]
                    #If there is a piece there, jumpable can stay False, and we add a reason
                    else: 
                        jumped_piece = move[1][2]
                        no_jump_reason = "Occupied"
                #If there's no valid space, we add that as a reason
                else: no_jump_reason = "No space"
            move_list.append({"Target": target, "Free": free, "No jump reason": no_jump_reason, "Jumped piece": jumped_piece})
        return(piece_info, move_list)



    def move(self, board_df, target):
        #Get move data
        piece_info, move_list = self.available_moves(board_df)
        #Get target from move list (existing with an error if the target wasn't in the list)
        try:
            chosen_move = [i for i in move_list if i.get("Target") == target]
        except:
            return("Move error")
        current_space = piece_info.get("Space")
        jumped_piece = chosen_move.get("Jumped picece")
        #Update the piece's location
        current_space.piece = None
        target.piece = self
        #Adjust for values
        if jumped_piece != None:
            jumped_piece.charge -= 1
            self.charge += 1
            moves -= 2
        else:
            moves -= 1
        

#I haven't added move cost management


class Board():
        
    class Space():
        def __init__(self, q, r):
            self.q = q
            self.r = r
            self.piece = None

    def __init__(self, players_df, board_size = 7):
        self.board_size = board_size
        self.board_df = []
        self.players_df = players_df

    def set_up(self):
        #Map the board
        #First column number of top row
        start_col = math.floor(self.board_size/2)
        #Number of columns in first row
        cols = math.ceil(self.board_size/2)
        #Row number of middle row
        midway = math.ceil(self.board_size/2) - 1
        #Create each row
        for r in range(self.board_size):
            #Create each column (q) in the row, appending each to the board
            for q in range(start_col, start_col + cols):
                #Board contains written address, space object, and piece (though that's blank for now)
                self.board_df.append(["{0},{1}".format(q,r),self.Space(q,r),None])
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
        #Loop over the players so we can assign their objects as owners
        for p in self.players_df:
            piece = 0
            first_row = 0
            second_row = 1
            #Switches from down from the top row to up from the bottom row for player1
            if p.name == "player1":
                first_row = bottom_row
                second_row = bottom_row - 1
            #Loop over the board array
            for e in self.board_df:
                #Add pieces to the board in every space of the first row, and every odd space of the second row
                if e[1].r == first_row or (e[1].r == second_row and e[1].q % 2 != 0):
                    e[2] = Piece(piece,p)
                    piece += 1

        return(self.board_df)

    def view_board(self, board_df):
        #Returns a list of all spaces on the board, and pieces on those spaces where they exist
        board_layout = []
        for e in board_df:
            board_layout.append(e)
        return(board_layout)

def search(df, position, target):
    result = []
    for i in df:
        if i[position] == target:
            result = i
    return(result)

# Build dataframes
#Set up players
player_count = 2
players_df = []
for i in range(0, player_count):
    players_df.append(Player(i))

# Set up the board
board_size = 5
board = Board(players_df, board_size)
board_df = board.set_up()

print(players_df[0].my_pieces(board_df))