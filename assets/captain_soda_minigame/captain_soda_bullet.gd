extends Node2D

var move_speed = 5
var move_angle = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(move_angle) * move_speed
	pass

func on_area_entered (area):
	
	if area.get_parent().get_parent().name == "Enemies":
		area.get_parent().die()
		expire()
		
	
	pass

func expire():
	if !is_instance_valid(self): return
	
	# Destroy
	get_parent().remove_child(self)
	call_deferred("queue_free")
	
	pass
