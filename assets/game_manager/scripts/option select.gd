extends Area2D

signal play_button_pressed

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var is_hovering = false


func _on_body_entered(_body: Node2D) -> void:
	is_hovering = true

func _on_body_exited(_body: Node2D) -> void:
	is_hovering = false

func _process(_delta:float):
	if is_hovering and Input.is_action_just_released("fire"):
		animated_sprite_2d.animation=("click")
		play_button_pressed.emit()
	elif is_hovering:
		animated_sprite_2d.animation=("hover")
	else:
		animated_sprite_2d.animation=("default")
