extends RigidBody2D

var speed =200
var velocity=Vector2()
var mouse_position = null


# Called when the node enters the scene tree for the first time.
func _physics_process(delta) -> void:
	#velocity = Vector2(0,0)
	mouse_position=get_global_mouse_position()
	
	var direction = (mouse_position-position).normalized()
	velocity=(direction*speed*delta)
		
	
	
	#move_and_slide(velocity)
			
