extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D
var is_hovering = false

signal play_button_pressed

var already_pressed = false

func _on_area_entered(_area: Area2D) -> void:
	is_hovering = true

func _on_area_exited(_area: Area2D) -> void:
	is_hovering = false

func _on_body_entered(_body: Node2D) -> void:
	is_hovering = true

func _on_body_exited(_body: Node2D) -> void:
	is_hovering = false

func _process(_delta:float):
#Animate the Button
	if (not already_pressed and is_hovering==true and Input.is_action_just_pressed("fire")):
		animated_sprite_2d.animation=("click")
		play_button_pressed.emit()
		print ("click! bubbleware")
		already_pressed = true
	elif is_hovering == true:
		animated_sprite_2d.animation=("hover")
	else:
		animated_sprite_2d.animation=("default")
