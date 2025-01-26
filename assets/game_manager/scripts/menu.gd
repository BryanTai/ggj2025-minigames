extends Node2D

@onready var menu_music: AudioStreamPlayer = $MenuMusic

func _on_play_button_pressed() -> void:
	print("LOAD GAME")
	get_tree().change_scene_to_file("res://game_manager/mini_game_manager.tscn")

func _on_bubble_ware_voices_finished() -> void:
	menu_music.play()
