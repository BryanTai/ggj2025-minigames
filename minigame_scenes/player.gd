extends Area2D

## A controllable representation of the Player in 2D space
# use the Area2D.area_entered(area) signal for Collision detection

@export var player_speed: int = 200 #TODO: Adjust this speed as you see fit
var target_pos: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# This handles Horizontal movement
	#var horizontal_direction := Input.get_axis("move_left", "move_right")
	#if(horizontal_direction != 0):
		#var old_pos = position
		#var new_x = old_pos.x + (horizontal_direction * player_speed * delta);
		#set_position(Vector2(new_x, old_pos.y))
	
	# This handles Vertical movement
	var vertical_direction := Input.get_axis("move_up", "move_down")
	
	if(vertical_direction != 0):
		var old_pos = position
		var new_y = old_pos.y + (vertical_direction * player_speed * delta);
		set_position(Vector2(old_pos.x, new_y))
	
	# This will move the character player towards the mouse cursor
	# ATTENTION: Replace "player_speed" with whatever speed you have in your minigame!
	#elif target_pos:
		#global_position = global_position.move_toward(target_pos, player_speed * delta)

## Defines a target_pos variable to match the mouse cursor's position if mouse
## movement is detected.
func _input(event):
	if event is InputEventMouseMotion:
		target_pos = event.position
