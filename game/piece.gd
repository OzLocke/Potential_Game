extends Area2D

var colours = [Color("Red",0.5),Color("Blue", 0.5)]
var charge
var location

# Called when the node enters the scene tree for the first time.
func _ready():
	charge = 3
	$Sprite.modulate = colours[get_parent().player_number]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_released("Click"):
		for space in get_tree().get_nodes_in_group("spaces"):
			space.modulate = "ffffff6c"
		get_parent().available_moves(self)

