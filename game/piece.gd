extends Area2D

var colours = [Color("Red"),Color("Blue")]
var charge
var location
var move_choices = []
var moves
var selected = false
var pos = null
signal move_complete
# Called when the node enters the scene tree for the first time.
func _ready():
	#Set up piece
	#Set charge
	charge = 3
	moves = charge
	#Set colour based on owner
	$Sprite.modulate = colours[get_parent().player_number]
	#Add to group (note the group is created when the first piece is added to it
	add_to_group("pieces")
	#Set the piece's name to be PieceX where X is the piece's number
	self.name = "Piece%s" % str(get_tree().get_nodes_in_group("pieces").size() - 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if pos != null:
		global_position = global_position.move_toward(pos, 10)
	if global_position == pos:
		move_complete.emit()
	if selected:
		$Label.text = "%s/%s" % [moves,charge]
	else:
		$Label.text = "%s" % [charge]

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_released("Click"):
		#Set all pieces to not selected
		for piece in get_tree().get_nodes_in_group("pieces"):
			selected = false
		#Set this piece to selected
		selected = true
		#Reset all spaces to default colour
		for space in get_tree().get_nodes_in_group("spaces"):
			space.clear()
		#Display available moves for the selected piece
		available_moves()

func available_moves():
	#Finds available moves for a piece when it is clicked
	#What changes need to be made to the space reference to check neighbours?
	#[[NW],[NE],[W],[E],[SW],[SE]]
	var scan = [[0,-1],[+1,-1],[-1,0],[+1,0],[-1,+1],[0,+1]]
	#A list of all piece locations
	var pieces = get_tree().get_nodes_in_group("pieces")
	var spaces = get_tree().get_nodes_in_group("spaces")
	var moves = []
	for test in scan:
		#Set the target addresses to test in relation to the piece's current space
		var target_1 = [location.q + test[0], location.r + test[1]]
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
		#is there a piece in the space?
		var target_2_free = true
		for piece in pieces:
			if piece.location.q == target_2[0] and piece.location.r == target_2[1]:
				target_2_free = false
				break
		
		#Based on the above conditions, colour available move spaces and register move details		
		if target_1_real and target_1_free:
			for space in spaces:
				if space.q == target_1[0] and space.r == target_1[1] and self.moves >= 1:
					moves.append([target_1, null])
					space.highlight()
		elif target_2_real and target_2_free and self.moves >= 2:
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
	move_choices = move_nodes
		
func move(destination):
	#move the selcted piece
	for move in move_choices:
		if move[0] == destination:
			if move[1] != null:
				moves -= 2
				move[1].charge -= 1
				charge += 1
			else:
				moves -= 1
			print(moves)
	pos = destination.global_position
	selected = false
	location = destination

func _on_move_complete():
	pos = null
	#Reset all spaces to default colour
	for space in get_tree().get_nodes_in_group("spaces"):
		space.clear()
