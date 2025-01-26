extends RigidBody2D

var SPEED = 600
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta):
	
	var directionx := Input.get_axis("move_left", "move_right")
	var directiony := Input.get_axis("move_up","move_down")
	
	#	if inpu_event(""):
	if Input.is_action_pressed("fire"):
		animated_sprite_2d.animation = "click"
	else:
		animated_sprite_2d.animation = "default"
	

	if directionx:
		linear_velocity.x=directionx *SPEED
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, SPEED)
				
	if directiony:
		linear_velocity.y=directiony *SPEED

	else:
		linear_velocity.y = move_toward(linear_velocity.y, 0, SPEED)

	
	
#var mouseposition
#var cursordirection=Vector2(0,0)
  	
#func _process(delta):
#		mouseposition = get_local_mouse_position()
#		
#		cursordirection=mouseposition-position
#				
#		#rotation+= mouseposition.angle() * 0.1
#		position+= cursordirection
#		print (cursordirection)
