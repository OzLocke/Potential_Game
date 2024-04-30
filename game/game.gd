extends Control
var state
var active_player
#Rules inlcude "2_to_jump", "no_double_jumps"
var rules = []

# Called when the node enters the scene tree for the first time.
func _ready():
	active_player = $Player1
	$CurrentPlayer.text = "%s's turn" % [active_player.player_name]
	$Rules.text = "Rules:"
	for rule in rules:
		$Rules.text = $Rules.text + "\n" + rule.replace("_", " ")
	for piece in get_tree().get_nodes_in_group("pieces"):
		piece.show_state()
	self.state = "waiting"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.state == "game_over":
		$EndScreen.visible = true

func set_state(state):
	self.state = state
	
func end_turn():
	#Lose a point of charge if at the Bleeding Edge
	for piece in get_tree().get_nodes_in_group("pieces"):	
		if piece.location.outer:
			piece.charge -= 1
		if piece.charge <= 0:
			piece.queue_free()
	
	var players = get_tree().get_nodes_in_group("players")
	var active_player_index = players.find(active_player)
	#This will result in a 1 or a 0 based on the index, letting us toggle the active player
	var next_player_index = active_player_index - 1
	self.active_player = players[next_player_index]
	$CurrentPlayer.text = "%s's turn" % [active_player.player_name]
	for piece in get_tree().get_nodes_in_group("pieces"):
		piece.show_state()
		
	self.state = "waiting"
	
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
		print("game over")
		self.set_state("game_over")
		
	
