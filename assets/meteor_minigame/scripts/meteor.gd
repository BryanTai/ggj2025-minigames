extends Area2D

@export var falling_speed: int = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_position = Vector2(position.x, position.y + (delta * falling_speed))
	set_position(new_position)

func _test_function() -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	var explosion_resource = load("res://assets/meteor_minigame/scenes/explosion.tscn")
	var explosion = explosion_resource.instantiate()
	explosion.set_position(global_position)
	get_parent().add_child(explosion)
	queue_free()
