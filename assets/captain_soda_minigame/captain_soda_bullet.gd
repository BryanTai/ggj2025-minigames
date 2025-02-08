extends Node2D

var move_speed = 5
var move_angle = 0

func _process(_delta: float) -> void:
	position += Vector2.RIGHT.rotated(move_angle) * move_speed

func on_bullet_hit(area: Area2D):
	area.die()
	queue_free()
