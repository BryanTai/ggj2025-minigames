class_name GameOverScreen extends Node2D

@onready var score_number: Label = $ScoreLabel/ScoreNumber

func _ready() -> void:
	score_number.text = str(ScoreKeeper.wins)

# Listen for button signal to restart game
func _on_play_button_pressed() -> void:
	print("RESTART GAME")
	get_tree().change_scene_to_file("res://game_manager/menu.tscn")
