extends Node2D
var player_name = self.name
@export var player_number = 0
var start_locations = [
	#Player 1
	[[2,0],[3,0],[4,0],[2,1],[3,1]],
	#Player 2
	[[1,3],[2,3],[0,4],[1,4],[2,4]]
	]
var piece = preload("res://piece.tscn")
var my_pieces = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#Get the objects with the relevent addresses
	var spaces = get_tree().get_nodes_in_group("spaces")
	for space in spaces:
		var address = [space.q,space.r]
		if address in start_locations[player_number]:
			var instance = piece.instantiate()
			instance.global_position = space.global_position
			instance.location = space
			my_pieces.append(instance)
			add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func available_moves(piece):
	#Takes a piece. Checks neighbours and returns a list of empty spaces.
	#Get a list of all spaces, with both the object itself, and the address
	var board_df = []
	for space in get_tree().get_nodes_in_group("spaces"):
		board_df.append([space, [space.q, space.r]])
	var piece_locations = []
	var pieces = []
	for player in get_tree().get_nodes_in_group("players"):
		for i in player.my_pieces:
			piece_locations.append(i.location)
			pieces.append(i)
	#What changes need to be made to the space reference to check neighbours?
	#[[NW],[NE],[W],[E],[SW],[SE]]
	var scan = [[0,-1],[+1,-1],[-1,0],[+1,0],[-1,+1],[0,+1]]
	#This will hold jump data
	#[target space, jumped piece]
	var jumps = []
	for test in scan:
		#Set the target addresses to test in relation to the piece's current space
		var target = [piece.location.q + test[0], piece.location.r + test[1]]
		var target_2 = [target[0] + test[0], target[1] + test[1]]
		#These will hold the spaces identified by the tests
		var result
		var result_2
		#Loop over the spaces to find the right one
		for space in board_df:
			#Add the spaces to the spaces found by the test to the result variables
			if space[1] == target:
				result = space[0]
			if space[1] == target_2:
				result_2 = space[0]
			#If the first target is a match and there is no piece there
			if result != null and result not in piece_locations:
				#Set it's colour
				result.modulate = Color("Green")
			if result != null and result in piece_locations and result_2 != null and result_2 not in piece_locations:
				#Set it's colour
				result_2.modulate = Color("Green")
				#If this section triggered it means there was a piece in the first space. We need to record this
				for i in pieces:
					var loc = [i.location.q, i.location.r]
					if loc == target:
						jumps.append([result_2, i])
	

			
			#for i in range(board_df.size()):
			#if board_df[i].find(target) != -1:
			#	print(board_df[i])
