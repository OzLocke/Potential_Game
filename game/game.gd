extends Control
var state
var active_player

# Called when the node enters the scene tree for the first time.
func _ready():
	active_player = $Player1
	$CurrentPlayer.text = "%s's turn" % [active_player.player_name]
	for piece in get_tree().get_nodes_in_group("pieces"):
		piece.show_state()
	self.state = "waiting"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_state(state):
	state = state
	
func change_turn():
	var players = get_tree().get_nodes_in_group("players")
	var active_player_index = players.find(active_player)
	#This will result in a 1 or a 0 based on the index, letting us toggle the active player
	var next_player_index = active_player_index - 1
	self.active_player = players[next_player_index]
	$CurrentPlayer.text = "%s's turn" % [active_player.player_name]
	self.state = "waiting"
