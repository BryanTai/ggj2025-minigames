extends Node2D

var mini_game_manager_resource: Resource

func _ready() -> void:
	mini_game_manager_resource = preload("res://game_manager/mini_game_manager.tscn")

func _on_play_button_pressed() -> void:
	print("LOAD GAME")
	var manager = mini_game_manager_resource.instantiate()
	get_tree().root.add_child(manager)
	queue_free()
