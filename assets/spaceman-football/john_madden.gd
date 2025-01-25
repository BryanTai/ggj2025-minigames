extends BaseMiniGame


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instruction_text = "Field Goal"
	disable_minigame_during_intro_and_outro=false
	super()


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	
	trigger_game_win()
	pass # Replace with function body.
