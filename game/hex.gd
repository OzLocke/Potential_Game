extends Area2D
@export var q: int = 0
@export var r: int = 0
var highlighted = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func highlight():
	self.modulate = Color("Green")
	highlighted = true
	
func clear():
	self.modulate = "ffffff6c"
	highlighted = false
	
func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_released("Click") and highlighted:
		for piece in get_tree().get_nodes_in_group("pieces"):
			if piece.selected:
				piece.move(self)
		
