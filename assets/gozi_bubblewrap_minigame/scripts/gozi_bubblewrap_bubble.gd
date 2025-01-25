extends Node2D

var is_hovering = false

@onready var animated_sprite_2d = $AnimatedSprite2D

func _on_area_entered(body):
	is_hovering = true

func _on_area_exited(body):
	is_hovering = false

func _process(_delta:float):
	if (is_hovering and Input.is_action_just_pressed("fire") and $AnimatedSprite2D.animation == "whole1"):
		animated_sprite_2d.stop()
		animated_sprite_2d.animation = "popped2"
		animated_sprite_2d.play()
		$AudioStreamPlayer.play()
