extends Node2D

#Instantiate
var rng = RandomNumberGenerator.new()
var enemy_object
signal enemy_died(enemy_name)

#Parameters
@onready var enemy_index 			= randi_range(0, 3) # Enemy number
@onready var random_offset 			= randf()
@onready var move_position_angle 	= deg_to_rad(random_offset * 360)
@onready var move_direction 		= [1, -1].pick_random() # Left/right
@onready var move_speed 			= randf_range(100, 400)	# How much the enemy will move / greater distance
@onready var move_rotation_speed 	= 360 * randf_range(0.5, 2)	# How quickly an enemy will rotate


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Choose a random sprite
	enemy_object = get_child(enemy_index)
	enemy_object.visible = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Animate enemy
	if enemy_object.name == "Ghost" || enemy_object.name == "Mother" || enemy_object.name == "Bomb":
		
		move_position_angle += deg_to_rad(move_rotation_speed * delta * move_direction)
		position += Vector2.from_angle(move_position_angle) * (move_speed * delta)
		
	elif enemy_object.name == "Spinner":
		var _rotation_speed = 180 
		rotation += deg_to_rad(_rotation_speed * delta)
	
	

func die():
	
	# Destroy
	get_parent().remove_child(self)
	queue_free()
	
	enemy_died.emit(enemy_object.name)
	
