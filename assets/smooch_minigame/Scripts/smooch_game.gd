extends BaseMiniGame



# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_area_entered(area: Area2D) -> void:
	if area.get("name") == "Player":
		trigger_game_win()
		print ("win")
	else:
		print (area.get("name"))
		pass



func _on_fail_wall_area_entered(area: Area2D) -> void:
	if area.get("name") == "Smoocher":
		trigger_game_lose()
		print ("lose")
	else:
		print (area.get("name"))
		pass
