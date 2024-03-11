extends Node2D
@export var player_name = "hold"
@export var player_number = 0
var start_locations = [
	#Player 1
	[[2,0],[3,0],[4,0],[2,1],[3,1]],
	#Player 2
	[[1,3],[2,3],[0,4],[1,4],[2,4]]
	]
var child_piece = preload("res://piece.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#Get the objects with the relevent addresses
	var spaces = get_tree().get_nodes_in_group("spaces")
	for i in spaces:
		var address = [i.q,i.r]
		if address in start_locations[player_number]:
			var instance = child_piece.instantiate()
			instance.global_position = i.global_position
			add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
