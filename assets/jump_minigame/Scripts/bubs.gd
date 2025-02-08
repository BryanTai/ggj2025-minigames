extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const RUNSPEED = 500.0
const JUMP_VELOCITY = -2000.0

var target_x_pos: float
var mouse_priority: bool = false
var mouse_x_buffer: float = 10.0

	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 6
		animated_sprite_2d.animation = "jump"
	else:
		animated_sprite_2d.animation = "run"
		if rotation > 0:
			animation_player.play("RESET")
	
	# use keyboard input
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		mouse_priority = false
	
	# use mouse input
	if not direction and mouse_priority:
		direction = 1
		if target_x_pos < position.x:
			direction = -1
		if abs(target_x_pos - position.x) < mouse_x_buffer:
			direction = 0
	
	# Jump
	if(Input.is_action_just_pressed("fire")) and is_on_floor():
			velocity.y = JUMP_VELOCITY
			animation_player.play("rotate")
	
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
