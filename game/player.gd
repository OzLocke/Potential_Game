extends Node2D
@export var player_name = "player"
@export var player_number = 0
var start_locations = [
	#Player 1
	[[2,0],[3,0],[4,0]],
	#Player 2
	[[0,4],[1,4],[2,4]]
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

