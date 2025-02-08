extends Area2D
@onready var smooch_mini_game: Node2D = $".."


var v_range := 0.8
var smoocher_speed := 275
var v_direction := randf_range(-v_range, v_range)
var direction := Vector2(v_direction,v_direction).normalized()
var timer := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(1200, randf_range(150, 850))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if smooch_mini_game.current_state < 2:
		if timer == 40:
			v_direction = randf_range(-v_range, v_range)
			print (timer)
		elif timer == 80:
			print (timer)
			v_direction = randf_range(-v_range, v_range)
		
		if position.y < 200:
			v_direction = v_range
		if position.y > 800:
			v_direction = -v_range
		
		direction = Vector2(-1,v_direction).normalized()
		position += direction * smoocher_speed * delta
		timer += 1
	
	pass
