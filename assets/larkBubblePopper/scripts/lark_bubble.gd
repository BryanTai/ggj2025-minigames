extends Area2D
const SPEED: int = 150
var iscat: bool = false
func _ready() -> void:
	# BorkStick - On this day, 2025-01-24, the noble Borkstick bestowed their redeem to complete that Final Fantasy quote thingamajig. Little did they know, they couldn’t be bothered to look it up. Truly a tale of legend... or laziness.
	var randomcat = randi_range(1,100)
	if(randomcat > 70):
		iscat = true
		$Sprite2D.texture = load("res://assets/larkBubblePopper/sprites/larkcatbubble.png")

func _process(delta: float) -> void:
	position = Vector2(position.x, position.y - (delta * SPEED))
	

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
	if event.is_action_pressed("leftClick"):
		if(iscat):
			print("you clicked")
			$"..".bubbleWasPopped()
			queue_free()
