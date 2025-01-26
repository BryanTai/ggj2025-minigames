extends BaseMiniGame


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instruction_text = "JUMP!" 
	
	## Set this flag to "false" in your MiniGame if you don't want everything disabled outside of the PLAYING state
	disable_minigame_during_intro_and_outro = false
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timeout() -> void:
	trigger_game_win()
		


func _on_killzone_body_entered(body: Node2D) -> void:
	if body.get("name") == "Bubs":
		trigger_game_lose()
