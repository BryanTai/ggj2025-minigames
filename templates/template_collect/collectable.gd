class_name Collectable
extends Area2D

# Deletes the Collectable when it collides with something (the Player)

func _ready() -> void:
	area_entered.connect(_on_collided)
	
func _on_collided(_area: Area2D) -> void:
	queue_free()
