extends Node2D

var popped = false

#func _process_playing_state(delta: float) -> void:
	#if $AnimatedSprite2D.animation == "whole1" and popped == true:
		

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and $AnimatedSprite2D.animation == "whole1":
		popped = true
		$AnimatedSprite2D.play("popped2")
