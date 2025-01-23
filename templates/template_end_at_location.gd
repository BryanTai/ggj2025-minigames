extends BaseMiniGame

## This is a template for a MiniGame where the player controls an object and must move it to a specific location in 2D space
# Delete either Horizontal or Vertical movement if you just want to move in 1 dimension

@onready var player: Area2D = $Player
@onready var goal: Area2D = $Goal

@export var player_speed: int = 100 #TODO: Adjust this speed as you see fit

func _ready() -> void:
	goal.area_entered.connect(on_goal_collided)
	super()
	instruction_text = "Move!" #TODO: Replace this with your instructions!
	

func _process(delta: float) -> void:
	super(delta)
	
	# This handles Horizontal movement
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	if(horizontal_direction != 0):
		var old_pos = player.position
		var new_x = old_pos.x + (horizontal_direction * player_speed * delta);
		player.set_position(Vector2(new_x, old_pos.y))
	
	# This handles Vertical movement
	var vertical_direction := Input.get_axis("move_up", "move_down")
	if(vertical_direction != 0):
		var old_pos = player.position
		var new_y = old_pos.y + (vertical_direction * player_speed * delta);
		player.set_position(Vector2(old_pos.x, new_y))

func on_goal_collided(area: Area2D) -> void:
	print("Wahoo!")
	trigger_game_win()
