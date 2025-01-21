extends BaseMiniGame

@onready var gun: Node2D = $Gun

func _ready() -> void:
	instruction_text = "SHOOT METEORS!"
	# This disables every Node in the Meteor mini game
	process_mode = Node.PROCESS_MODE_DISABLED
	
func _on_end_preparing_state() -> void:
	# Once the instruction banner goes away, enable all the nodes in the game
	process_mode = Node.PROCESS_MODE_INHERIT

func _on_timeout() -> void:
	trigger_game_win()

func _on_collision(area: Area2D) -> void:
	trigger_game_lose()
	
func _on_end_playing_state() -> void:
	# Win or lose, disable the Gun controls
	gun.process_mode = Node.PROCESS_MODE_DISABLED
