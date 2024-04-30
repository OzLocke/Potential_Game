extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_up():
	#Once I have dedicated scenes for start and end, this should be replaced with a more code-based retsart
	get_tree().reload_current_scene()
