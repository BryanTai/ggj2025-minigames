extends BaseMiniGame

@onready var gun: Node2D = $Gun

func _ready() -> void:
	instruction_text = "SHOOT METEORS!"

# If we make it to the Timeout, we win
func _on_timeout() -> void:
	trigger_game_win()

# If a Meteor collides with the Ground, we lose
func _on_collision(area: Area2D) -> void:
	trigger_game_lose()
	
func _on_end_playing_state() -> void:
	# Win or lose, disable the Gun controls
	gun.process_mode = Node.PROCESS_MODE_DISABLED
