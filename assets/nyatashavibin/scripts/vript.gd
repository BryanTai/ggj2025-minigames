extends Node2D

var goodvibes = ["slimes", "bubs", "anime", "kitties", "ponies","coffee", "baking", "Pride"]
var badvibes = ["twitter", "taxes", "HOAs", "overtime", "migraines", "landlords", "hangnails", "karens"]
var isbad = false
@onready var vabel: Label = $vabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var badnumber = randi_range(0,1)
	if(badnumber == 0):
		isbad = false
	else:
		$vubble.texture = load("res://assets/nyatashavibin/sprites/BadBub.png")
		isbad = true
	if(isbad):
		vabel.text = badvibes[randi_range(0, badvibes.size() -1)]
	else:
		vabel.text = goodvibes[randi_range(0, badvibes.size() -1)]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = global_position.move_toward(Vector2(511,537), delta * 200)
	
