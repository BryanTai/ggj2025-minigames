extends Area2D

const SPEED: int = 400

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_position = Vector2(position.x, position.y - (delta * SPEED))
	set_position(new_position)
	
	# Destroy the bullets at the top of screen
	if(position.y < 0):
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	queue_free()
