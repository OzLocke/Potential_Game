extends AspectRatioContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func new_turn():
	var game = get_parent()
	game.change_turn()
	for space in get_children():
		space.clear()
	for piece in get_tree().get_nodes_in_group("pieces"):
		piece.show_state()

