extends Area2D

#Instantiate
var enemy_object
signal enemy_died(enemy_name)

#Parameters
var enemy_index 			:= randi_range(0, 3) # Enemy number
var random_offset 			:= randf()
var move_position_angle 	:= deg_to_rad(random_offset * 360)
var move_direction			:= randi_range(1, -1) # Left/right
var move_speed 				:= randf_range(100, 400)	# How much the enemy will move / greater distance
var move_rotation_speed 	:= 360 * randf_range(0.5, 2)	# How quickly an enemy will rotate


func _ready() -> void:
	# Choose a random sprite
	enemy_object = get_child(enemy_index)
	enemy_object.visible = true

func _process(delta: float) -> void:
	# Animate enemy	
	if enemy_object.name == "Spinner":
		var _rotation_speed = 180 
		rotation += deg_to_rad(_rotation_speed * delta)
	elif move_direction:
		move_position_angle += deg_to_rad(move_rotation_speed * delta * move_direction)
		position += Vector2.from_angle(move_position_angle) * (move_speed * delta)

func die():
	enemy_died.emit(enemy_object.name)
	queue_free()
