class_name Player2D
extends Area2D

## A controllable representation of the Player in 2D space
# use the Area2D.area_entered(area) signal for Collision detection

@export var player_speed: int = 200 #TODO: Adjust this speed as you see fit
var target_pos: Vector2

var movement_enabled = true

var mouse_priority: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(not movement_enabled):
		return
	
	if mouse_priority:
		global_position = global_position.move_toward(target_pos, player_speed * delta)
	else:
		var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		if direction:
			position += direction * player_speed * delta
	

## Defines a target_pos variable to match the mouse cursor's position if mouse
## movement is detected.
func _input(event):
	if(not movement_enabled):
		return
	
	if event is InputEventMouseMotion:
		target_pos = event.position
		mouse_priority = true
