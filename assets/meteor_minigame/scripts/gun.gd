extends Node2D

@export var gun_speed: int = 400

const BULLET = preload("res://assets/meteor_minigame/scenes/bullet.tscn")
@onready var meteor_mini_game: Node2D = $".."
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var target_x_pos: float
var mouse_priority: bool = false
var mouse_x_buffer: float = 10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
			
	var new_x = position.x + (direction * gun_speed * delta)
	set_position(Vector2(new_x, position.y))
		
	# Shoot Bullet
	if(Input.is_action_just_pressed("fire")):
		#print("fire!")
		var bullet_instance = BULLET.instantiate() as Area2D
		meteor_mini_game.add_child(bullet_instance)
		bullet_instance.set_position(global_position)
		audio_stream_player.play()

## Match the player to the mouse if mouse movement is detected
func _input(event):
	if event is InputEventMouseMotion:
		mouse_priority = true
		target_x_pos = event.position.x
