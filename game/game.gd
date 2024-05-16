extends Control
var state
var active_player
var active_piece = null
#Rules inlcude "2_to_jump", "no_double_jumps"
var rules = []
var jump_cost = 0
var move_choices = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if "2_to_jump" in self.rules: self.jump_cost = 1
	active_player = $Player1
	$CurrentPlayer.text = "%s's turn" % [active_player.player_name]
	$Rules.text = "Rules:"
	for rule in rules:
		$Rules.text = $Rules.text + "\n" + rule.replace("_", " ")
	for piece in get_tree().get_nodes_in_group("pieces"):
		piece.show_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func end_turn():
	active_piece = null
	var players = get_tree().get_nodes_in_group("players")
	var active_player_index = players.find(active_player)
	#This will result in a 1 or a 0 based on the index, letting us toggle the active player
	var next_player_index = active_player_index - 1
	self.active_player = players[next_player_index]
	$CurrentPlayer.text = "%s's turn" % [active_player.player_name]
	for piece in get_tree().get_nodes_in_group("pieces"):
		piece.show_state()
	clear()	
	check_game()
	
func check_game():
	var player_1 = $Player1
	var player_2 = $Player2
	var p1_pieces = 0
	var p2_pieces = 0
	for piece in get_tree().get_nodes_in_group("pieces"):
		if piece.piece_owner == player_1:
			p1_pieces += 1
		if piece.piece_owner == player_2:
			p2_pieces += 1
	if p1_pieces <= 0 or p2_pieces <= 0:
		clear()
		print("game over")
		$EndScreen.visible = true
		
func available_moves(start):
	#Finds available moves for a piece when it is clicked
	#What changes need to be made to the space reference to check neighbours?
	#[[NW],[NE],[W],[E],[SW],[SE]]
	var scan = [[0,-1],[+1,-1],[-1,0],[+1,0],[-1,+1],[0,+1]]
	#A list of all piece locations
	var pieces = get_tree().get_nodes_in_group("pieces")
	var spaces = get_tree().get_nodes_in_group("spaces")
	var moves = []
	self.move_choices = []
	for test in scan:
		#Set the target addresses to test in relation to the piece's current space
		var target_1 = [start.location.q + test[0], start.location.r + test[1]]
		var target_2 = [target_1[0] + test[0], target_1[1] + test[1]]
		
		#is the taget a real space?
		var target_1_real = false
		for space in spaces:
			if space.q == target_1[0] and space.r == target_1[1]:
				target_1_real = true
				break
		#is there a piece in the space?
		var target_1_free = true
		for piece in pieces:
			if piece.location.q == target_1[0] and piece.location.r == target_1[1]:
				target_1_free = false
				break
		#is the taget a real space?
		var target_2_real = false
		for space in spaces:
			if space.q == target_2[0] and space.r == target_2[1]:
				target_2_real = true
				break
		#is the second space empty, and the jumped piece is jumpable?
		var target_2_free = true
		for piece in pieces:
			if piece.location.q == target_2[0] and piece.location.r == target_2[1]:
				target_2_free = false
				break
		#Is the piece jumpable (only active if given rule is active)
		if "no_double_jumps" in self.rules:
			for piece in pieces:
				if piece.location.q == target_1[0] and piece.location.r == target_1[1] and piece.jumpable == false:
					target_2_free = false
					break
		
		#Based on the above conditions, colour available move spaces and register move details		
		if target_1_real and target_1_free:
			for space in spaces:
				if space.q == target_1[0] and space.r == target_1[1] and start.moves_remaining >= 1:
					moves.append([target_1, null])
					space.highlight()
		elif target_2_real and target_2_free and start.moves_remaining >= jump_cost:
			for space in spaces:
				if space.q == target_2[0] and space.r == target_2[1]:
					moves.append([target_2, target_1])
					space.highlight()
					
	#Use jumps to create a list of target spaces and jumped pieces
	var move_nodes = []
	for move in moves:
		var nodes = []
		#get landing space
		for space in spaces:
			if space.q == move[0][0] and space.r == move[0][1]:
				nodes.append(space)
		#get jumped piece
		#only if there actually is a piece!
		if move[1] != null:
			for piece in pieces:
				if piece.location.q == move[1][0] and piece.location.r == move[1][1]:
					nodes.append(piece)
		else:
			nodes.append(null)
		#overwrite jump with new data
		move_nodes.append(nodes)
	#update the main moves variable with the list of current moves	
	self.move_choices = move_nodes

func clear():
	#Clear spaces
	for space in get_tree().get_nodes_in_group("spaces"):
		space.modulate = "ffffff6c"
		space.highlighted = false
	#Remove pieces with no charge
	for piece in get_tree().get_nodes_in_group("pieces"):
		if piece.charge <= 0:
			piece.remove_from_group("pieces")
			piece.queue_free()
