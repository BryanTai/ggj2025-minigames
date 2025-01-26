extends Player2D
var is_hovering = false

func _process(event):
	super(event)

	if Input.is_action_pressed("fire"):
		$PawCursor_AnimatedSprite2D.animation = "pressed"
	else:
		$PawCursor_AnimatedSprite2D.animation = "default"
