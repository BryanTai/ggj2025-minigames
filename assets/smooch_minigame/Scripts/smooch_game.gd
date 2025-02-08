extends BaseMiniGame



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instruction_text = "SMOOCH!" 
	
	## Set this flag to "false" in your MiniGame if you don't want everything disabled outside of the PLAYING state
	disable_minigame_during_intro_and_outro = false
	super()

func _on_player_area_entered(area: Area2D) -> void:
	if area.get("name") == "Smoocher":
		trigger_game_win()

func _on_fail_wall_area_entered(area: Area2D) -> void:
	if area.get("name") == "Smoocher":
		trigger_game_lose()
