extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# This represents the player's inertia.
var push_force = 80.0

var mouse_priority: bool = false
var target_pos: Vector2

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 0.5
		animated_sprite_2d.play("jump")
		
	# Handle jump.
	if Input.is_action_just_pressed("fire") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction: float
	
	if mouse_priority:
		if absf(position.x - target_pos.x) < 3:
			direction = 0
		else:
			direction = clamp(position.x - target_pos.x, -1, 1) * -1
	else:
		direction = Input.get_axis("move_left", "move_right")

	animated_sprite_2d.flip_h = direction < 0
	
	if is_on_floor():
		animated_sprite_2d.play("run")
		animated_sprite_2d.play("idle")
		
		
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			animated_sprite_2d.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			animated_sprite_2d.play("idle")

	move_and_slide()

	# after calling move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func _input(event):
	if event is InputEventMouse:
		target_pos = event.position
		mouse_priority = true
	else:
		mouse_priority = false
