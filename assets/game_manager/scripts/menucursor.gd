extends RigidBody2D

var SPEED = 600
var mouse_pos: Vector2
var is_using_mouse: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _process(delta):
	
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_just_pressed("fire"):
		animated_sprite_2d.animation = "click"
		_mouse_click()
		print("pressed at: ", position)
	
	if Input.is_action_just_released("fire"):
		animated_sprite_2d.animation = "default"

	if direction:
		linear_velocity = direction *SPEED
		get_viewport().warp_mouse(global_position)
		is_using_mouse = false
	elif is_using_mouse:
		global_position = global_position.move_toward(mouse_pos, delta * SPEED)
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, SPEED)
		linear_velocity.y = move_toward(linear_velocity.y, 0, SPEED)
  	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		_mouse_release()
	
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		is_using_mouse = true

func _mouse_click() -> void:
	var click := InputEventMouseButton.new()
	click.button_index = 1
	click.button_mask = MOUSE_BUTTON_MASK_LEFT
	click.pressed = true
	click.position = position
	Input.parse_input_event(click)
	print("click")
	
func _mouse_release() -> void:
	var click := InputEventMouseButton.new()
	click.button_index = 1
	click.button_mask = 0 
	click.pressed = false
	click.position = position
	Input.parse_input_event(click)
	print("unclick")
