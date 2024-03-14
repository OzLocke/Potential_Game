extends Area2D

var colours = [Color("Red",0.5),Color("Blue", 0.5)]
var charge
var location
var hover = false

# Called when the node enters the scene tree for the first time.
func _ready():
	charge = 3
	$Piece.modulate = colours[get_parent().player_number]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_released("Click"):
		charge -= 1
		$Label.text = str(charge)


func _on_mouse_entered():
	hover = true


func _on_mouse_exited():
	hover = false
