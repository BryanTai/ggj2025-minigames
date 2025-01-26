class_name LarkBubble extends Area2D

const SPEED: int = 150
var iscat: bool = false

func load_cat_sprite() -> void:
	# BorkStick - On this day, 2025-01-24, the noble Borkstick bestowed their redeem to complete that Final Fantasy quote thingamajig. Little did they know, they couldn’t be bothered to look it up. Truly a tale of legend... or laziness.
	$Sprite2D.texture = load("res://assets/larkBubblePopper/sprites/bubs_head.png")

func _process(delta: float) -> void:
	position = Vector2(position.x, position.y - (delta * SPEED))
