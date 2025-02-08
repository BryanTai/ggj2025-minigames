extends Area2D
@onready var smooch_mini_game: Node2D = $".."

## A controllable representation of the Player in 2D space
# use the Area2D.area_entered(area) signal for Collision detection

@export var player_speed: int = 200 #TODO: Adjust this speed as you see fit

var target_y_pos: float
var mouse_priority: bool = false
var mouse_y_buffer: float = 5.0

func _ready() -> void:
	position = Vector2(50, 300)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# This handles Vertical movement
	var vertical_direction := Input.get_axis("move_up", "move_down")
	
	if smooch_mini_game.current_state < 2:
		
		if mouse_priority:
			vertical_direction = 1
			if target_y_pos < position.y:
				vertical_direction = -1
			if abs(target_y_pos - position.y) < mouse_y_buffer:
				vertical_direction = 0

		var new_y = position.y + (vertical_direction * player_speed * delta);
		set_position(Vector2(position.x, new_y))

## Read the y position of the cursor if mouse is moved
func _input(event):
	if event is InputEventMouseMotion:
		mouse_priority = true
		target_y_pos = event.position.y
	else:
		mouse_priority = false
