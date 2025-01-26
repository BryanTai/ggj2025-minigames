extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var is_hovering = false

@onready var animated_sprite_2d = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	is_hovering = true

func _on_body_exited(body: Node2D) -> void:
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
