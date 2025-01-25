extends Player2D

var is_hovering = false

## Defines a target_pos variable to match the mouse cursor's position if mouse
## movement is detected.
func _input(event):
	if event is InputEventMouseMotion:
		target_pos = event.position

	if Input.is_action_pressed("fire"):
		$PawCursor_AnimatedSprite2D.animation = "pressed"
	else:
		$PawCursor_AnimatedSprite2D.animation = "default"

func _on_area_entered(area):
	is_hovering = true

func _on_area_exited(area):
	is_hovering = false
