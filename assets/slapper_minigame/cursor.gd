extends Player2D
var is_hovering = false
var smacked = false
var timer = 0
		
		
func _process(event):
	super(event)
	
	if smacked:
			timer += 1
			
	if not smacked:
		if Input.is_action_pressed("fire"):
			$Cursor_AnimatedSprite2D.animation = "pressed"

			smacked = true
		
	if timer > 4:
		$Cursor_AnimatedSprite2D.animation = "off"

	
				
