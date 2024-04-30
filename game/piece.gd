extends Area2D
#values for identifying owner
var colours = [Color("Red"),Color("Blue")]
var piece_owner
#values for managing piece from a game level
var charge
var location
var jumpable = true
var moves_remaining
var jump_cost = 1
#values for managing piece from a code level
var selected = false
var current_pos = null
var move_choices = []
var destroy_piece
var moving = false
#node storage
var game
var board
#signals
signal move_complete


# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_parent().get_parent()
	board = get_parent().get_parent().get_node("Board")
	piece_owner = get_parent()
	self.charge = 3
	self.moves_remaining = charge
	if "2_to_jump" in game.rules: self.jump_cost = 2
	#Set colour based on owner
	$Sprite.modulate = colours[get_parent().player_number]
	#Add to group (note the group is created when the first piece is added to it
	add_to_group("pieces")
	#Set the piece's name to be PieceX where X is the piece's number
	self.name = "Piece%s" % str(get_tree().get_nodes_in_group("pieces").size() - 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#Move the piece
	if self.current_pos != null:
		self.global_position = self.global_position.move_toward(self.current_pos, 10)
	if self.global_position == self.current_pos and self.moving == true:
		move_complete.emit()
	
	#Display info on the piece
	if selected:
		var moves_counter = self.moves_remaining
		if moves_counter < 0: moves_counter = 0
		$Label.text = "%s/%s" % [moves_counter,self.charge]
	else:
		$Label.text = "%s" % [self.charge]

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_released("Click") and self.game.active_player == self.piece_owner and self.selected == false and self.game.state == "waiting":
		self.game.state = "playing"
		#Set all pieces to not selected
		for piece in get_tree().get_nodes_in_group("pieces"):
			piece.selected = false
		#Set this piece to selected
		self.selected = true
		self.moves_remaining = self.charge
		#Display available moves for the selected piece
		available_moves()

func available_moves():
	#Finds available moves for a piece when it is clicked
	#Reset all spaces to default colour
	for space in get_tree().get_nodes_in_group("spaces"):
		space.clear()
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
		var target_1 = [self.location.q + test[0], self.location.r + test[1]]
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
		if "no_double_jumps" in game.rules:
			for piece in pieces:
				if piece.location.q == target_1[0] and piece.location.r == target_1[1] and piece.jumpable == false:
					target_2_free = false
					break
		
		#Based on the above conditions, colour available move spaces and register move details		
		if target_1_real and target_1_free:
			for space in spaces:
				if space.q == target_1[0] and space.r == target_1[1] and self.moves_remaining >= 1:
					moves.append([target_1, null])
					space.highlight()
		elif target_2_real and target_2_free and self.moves_remaining >= jump_cost:
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
		
func move(destination):
	#move the selcted piece
	var pieces_group = get_tree().get_nodes_in_group("pieces")
	for move in self.move_choices:
		#Runs only on the chosen move
		if move[0] == destination:
			#If a piece is jumped
			if move[1] != null:
				#move[1] is the jumped piece
				move[1].charge -= 1
				move[1].jumpable = false
				if move[1].charge <= 0:
					self.destroy_piece = move[1]
				self.charge += 1
				self.moves_remaining -= jump_cost
			else:
				#If the move didn't involve jumping a piece, all pieces are set to jumpable again
				for piece in pieces_group:
					piece.jumpable = true
				self.moves_remaining -= 1
					
	self.current_pos = destination.global_position
	self.location = destination
	self.moving = true

func _on_move_complete():
	self.moving = false
	self.current_pos = null
	#Reset all spaces to default colour
	for space in get_tree().get_nodes_in_group("spaces"):
		space.clear()
	if self.destroy_piece != null:
		self.destroy_piece.remove_from_group("pieces")
		self.destroy_piece.queue_free()
		self.destroy_piece = null
	self.game.check_game()
	if self.moves_remaining <= 0:
		end_turn()
	else:
		available_moves()
	

func show_state():
	#Denotes that the pieces are active during your turn
	if self.game.active_player == self.piece_owner:
		$Sprite.modulate.a = 1
	else:
		$Sprite.modulate.a = 0.5
		
func end_turn():
	#deselect piece
	self.selected = false
	#set all pieces as jumpable
	for piece in get_tree().get_nodes_in_group("pieces"):
		piece.jumpable = true
	#trigger a new turn
	self.game.end_turn()
