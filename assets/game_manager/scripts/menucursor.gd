extends RigidBody2D

var SPEED = 600
var mouse_pos: Vector2
var is_using_mouse: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _process(delta):
	
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_pressed("fire"):
		animated_sprite_2d.animation = "click"
	else:
		animated_sprite_2d.animation = "default"

	if direction:
		linear_velocity = direction *SPEED
	elif is_using_mouse:
		global_position = global_position.move_toward(mouse_pos, delta * SPEED)
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, SPEED)
		linear_velocity.y = move_toward(linear_velocity.y, 0, SPEED)
  	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		is_using_mouse = true
	else:
		is_using_mouse = false
