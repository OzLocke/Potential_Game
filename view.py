import math
import numpy as np

#I'm ill, I need to add comments!

def display_board(board, board_df):
    df = board.view_board(board_df)
    print("Here is the current state of the board:")
    for i in df:
        space_name = i[0]
        piece = i[2]
        owner = None
        if piece != None: owner = piece.owner
        owner_text = ""
        if owner != None: owner_text = "(owned by {0})".format(owner.name)
        piece_text = ""
        if piece != None: piece_text = piece.name

        print("Space: {0} | Piece: {1} {2}".format(space_name, piece_text, owner_text))
    #Print an empty line
    print("")


def display_my_pieces(player, board_df):
        pieces = player.my_pieces(board_df)
        print("Hi, {0}. Here are your pieces:\n".format(player.name))
        for entry in pieces:
            print("{0} has {1} charge and is at {2},{3}".format(entry[0].name, entry[0].charge, entry[1].q, entry[1].r))
        #Print an empty line
        print("")


def display_moves(board, piece, board_df, player):
    your_piece = piece.owner == player
    if not your_piece:
        print("Sorry, that piece belongs to your opponent.")
        return
	
    piece_info, move_list = board.available_moves(piece, board_df)
    print("You selected {0}, at {1},{2}, which has {3} charge.".format(
        piece_info.get("Piece").name, 
        piece_info.get("Space").q, 
        piece_info.get("Space").r, 
        piece_info.get("Piece").charge
        ))
    for i in move_list:
        target = i.get("Target")
        free = i.get("Free")
        no_jump_reason = i.get("No jump reason")
        jumped_piece = i.get("Jumped piece")
        if jumped_piece != None:
            jumped_piece_name = jumped_piece.name
            jumped_piece_charge = jumped_piece.charge
            jumped_piece_owner = jumped_piece.owner
            if jumped_piece_owner == player: jumped_piece_owner = "you" 
            else: jumped_piece_owner = jumped_piece_owner.name
        match no_jump_reason:
            case None:
                pass
            case "Occupied":
                no_jump_reason = "the space beyond it is occupied"
            case "No space":
                no_jump_reason = "there is no space beyond it"
                
        #if the space is free
            #if the move does not involve a jump
            #
            #if the move does involve a jump
        #if the space is not free
        if free:
            if jumped_piece == None:
                text = "Space {0},{1} is free.".format(target.q, target.r)
            else:
                text = "Space {0},{1} can be reached by jumping {2}, which belongs to {3} and has {4} charge.".format(target.q, target.r, jumped_piece_name, jumped_piece_owner, jumped_piece_charge)
        else:
            text = "Space {0},{1} is occupied and cannot be jumped because {2}.".format(target.q, target.r, no_jump_reason)
        print(text)
    #Print an empty line
    print("")
        
def list_players(players_df):
    print("This table seats the following players:")
    names = [p.name for p in players_df]
    print(", ".join(map(str,names)) + "\n")
