extends BaseMiniGame


func _ready() -> void:
	instruction_text = "JUMP!" 
	disable_minigame_during_intro_and_outro = false
	super()


func _on_timeout() -> void:
	trigger_game_win()
		

func _on_killzone_body_entered(body: Node2D) -> void:
	if body.get("name") == "Bubs":
		trigger_game_lose()
