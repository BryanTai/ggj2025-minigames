extends Area2D

@onready var cursor: Area2D = $"../Cursor"



var is_hovering = false

@onready var animated_sprite_2d = $AnimatedSprite2D

func _on_area_entered(collision_shape_2d):
	is_hovering = true

func _on_area_exited(collision_shape_2d):
	is_hovering = false


func _process(_delta:float):
#Animate the Button
	if (is_hovering==true and Input.is_action_pressed("fire")):
		animated_sprite_2d.animation=("click")
		print ("click! bubbleware")
	elif is_hovering == true:
		animated_sprite_2d.animation=("hover")
	else:
		animated_sprite_2d.animation=("default")
