extends Node2D

var colours = [Color("Red",0.5),Color("Blue", 0.5)]
var charge

# Called when the node enters the scene tree for the first time.
func _ready():
	charge = 3
	$Piece.modulate = colours[get_parent().player_number]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


