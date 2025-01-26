extends Player2D

func _process(delta: float) -> void:
	if(not movement_enabled):
		return
	
	# This handles Horizontal movement
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	if(horizontal_direction != 0):
		var old_pos = position
		var new_x = old_pos.x + (horizontal_direction * player_speed * delta);
		set_position(Vector2(clamp(new_x, 680, 730), old_pos.y))
		mouse_priority = false
	
	# This handles Vertical movement
	var vertical_direction := Input.get_axis("move_up", "move_down")
	if(vertical_direction != 0):
		var old_pos = position
		var new_y = old_pos.y + (vertical_direction * player_speed * delta);
		set_position(Vector2(old_pos.x, (clamp(new_y, 660, 680))))
		mouse_priority = false
		
	elif target_pos and mouse_priority:
		target_pos.x = clamp(target_pos.x, 680, 730)
		target_pos.y = clamp(target_pos.y, 660, 680)
		global_position = global_position.move_toward(target_pos, player_speed * delta)
