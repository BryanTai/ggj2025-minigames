extends BaseMiniGame

## This is a template for a MiniGame where the player controls an object and must move it to a specific location in 2D space
# Delete either Horizontal or Vertical movement if you just want to move in 1 dimension

@onready var goal: Area2D = $Goal

func _ready() -> void:
	goal.area_entered.connect(on_goal_collided)
	super()
	instruction_text = "Move!" #TODO: Replace this with your instructions!

func _process(delta: float) -> void:
	super(delta)

func on_goal_collided(area: Area2D) -> void:
	print("Wahoo!")
	trigger_game_win()
