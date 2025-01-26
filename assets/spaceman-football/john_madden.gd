extends BaseMiniGame


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instruction_text = "Field Goal"
	disable_minigame_during_intro_and_outro=false
	super()


func _on_area_2d_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	trigger_game_win()
