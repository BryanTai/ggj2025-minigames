extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var bubsAnimation: AnimationPlayer = $AnimationPlayer


const SPEED = 130.0
const RUNSPEED = 500.0
const JUMP_VELOCITY = -2000.0


var target_x_pos: float
var mouse_priority: bool = false
var mouse_x_buffer: float = 10.0

	
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	# use keyboard/joystick input
	if(direction != 0):
		mouse_priority = false
	
	# use mouse_input
	if(direction == 0 and mouse_priority):
		direction = 1
		if target_x_pos < position.x:
			direction = -1
		if abs(target_x_pos - position.x) < mouse_x_buffer:
			direction = 0
	
	# Jump
	if(Input.is_action_just_pressed("fire")):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			print ("fire")
			bubsAnimation.play("rotation")

	
	
	if not is_on_floor():
		velocity += get_gravity() * delta *6
		animated_sprite_2d.animation = "jump"
		velocity.x = 0
		#bubsAnimation.play("rotation")

	else:
		animated_sprite_2d.animation = "run"
	

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY


	if direction:
		velocity.x = direction * RUNSPEED
	else:
		velocity.x = move_toward(velocity.x, 0, RUNSPEED)

	move_and_slide()

## Match the player to the mouse if mouse movement is detected
func _input(event):
	if event is InputEventMouseMotion:
		mouse_priority = true
		target_x_pos = event.position.x
