extends CharacterBody2D

const SPEED = 300.0

var mouse_priority: bool = false
var mouse_pos: Vector2
func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
		mouse_priority = false
	elif mouse_priority and mouse_pos:
		var mouse_dir = position.direction_to(mouse_pos).normalized()
		velocity = mouse_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		mouse_priority = true
