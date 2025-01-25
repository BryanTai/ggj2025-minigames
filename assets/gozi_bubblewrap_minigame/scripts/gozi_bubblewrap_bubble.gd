extends Node2D

var popped = false
var is_hovering = false

func _on_start_playing_state():
	if popped == false:
		$AnimatedSprite2D/Area2D/CollisionShape2D.set_process(false)
		print("it's off")

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("fire") and $AnimatedSprite2D.animation == "whole1" and is_hovering:
		popped = true
		$AnimatedSprite2D.play("popped2")
		$AudioStreamPlayer.play()
		
func _on_area_entered(area):
	is_hovering = true

func _on_area_exited(area):
	is_hovering = false


func _on_area_2d_area_entered(area):
	pass # Replace with function body.
