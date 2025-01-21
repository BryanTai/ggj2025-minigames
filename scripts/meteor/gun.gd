extends Node2D

const SPEED: int = 400

const BULLET = preload("res://scenes/meteor/bullet.tscn")
@onready var meteor_mini_game: Node2D = $".."
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var is_game_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if(direction != 0):
		var old_pos = position
		var new_x = old_pos.x + (direction * SPEED * delta);
		set_position(Vector2(new_x, old_pos.y))
		
	# Shoot Bullet
	if(Input.is_action_just_pressed("fire")):
		print("fire!")
		var bullet_instance = BULLET.instantiate() as Area2D
		meteor_mini_game.add_child(bullet_instance)
		bullet_instance.set_position(global_position)
		audio_stream_player.play()
