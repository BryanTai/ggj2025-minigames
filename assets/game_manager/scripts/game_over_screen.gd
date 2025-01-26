extends Node2D

var main_menu_resource = preload("res://game_manager/menu.tscn")
@onready var score_number: Label = $ScoreLabel/ScoreNumber

var final_score: int = 0

func _ready() -> void:
	score_number.text = str(final_score)

# Listen for button signal to restart game
func _on_play_button_pressed() -> void:
	print("RESTART GAME")
	var main_menu = main_menu_resource.instantiate()
	get_tree().root.add_child(main_menu)
	queue_free()
