extends Area2D
@onready var smooch_mini_game: Node2D = $".."


var smoocher_speed = 300
var value = randf_range(-1, 1)
var direction = Vector2(value,value).normalized()
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2((get_viewport().size.x-50), (randf_range(150, get_viewport().size.y-100)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if smooch_mini_game.current_state == 0:
		if timer == 40:
			value = randf_range(-.9, .9)
			print (timer)
		elif timer == 80:
			print (timer)
			value = randf_range(-.9, .9)
		
		if position.y > 700:
			value = value * -1
		elif position.y < 0:
			value = value * -1
		
		direction = Vector2(-1,value).normalized()
		position += direction * smoocher_speed * delta
		timer += 1
	
	pass
