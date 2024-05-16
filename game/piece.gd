extends Area2D
#values for identifying owner
var colours = [Color("Red"),Color("Blue")]
var piece_owner
#values for managing piece from a game level
var charge
var location
var jumpable = true
var moves_remaining
#values for managing piece from a code level
var selected = false
var current_pos = null
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
	if Input.is_action_just_released("Click") and self.game.active_player == self.piece_owner and self.selected == false:
		self.game.clear()
		#Set this piece to selected
		game.active_piece = self
		self.selected = true
		self.moves_remaining = self.charge
		#Display available moves for the selected piece
		game.available_moves(self)

func move(destination):
	#move the selcted piece
	var pieces_group = get_tree().get_nodes_in_group("pieces")
	for move in self.game.move_choices:
		#Runs only on the chosen move
		#move[0] is the destination of the move
		if move[0] == destination:
			#If a piece is jumped
			if move[1] != null:
				#move[1] is the jumped piece
				move[1].charge -= 1
				move[1].jumpable = false
				self.charge += 1
				self.moves_remaining -= game.jump_cost
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
	self.game.clear()
	self.game.check_game()
	if self.moves_remaining <= 0:
		end_turn()
	else:
		game.available_moves(self)

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
	#Lose a point of charge if at the Bleeding Edge
	for piece in get_tree().get_nodes_in_group("pieces"):	
		if piece.location.outer:
			piece.charge -= 1
	self.game.clear()
	#trigger a new turn
	self.game.end_turn()
