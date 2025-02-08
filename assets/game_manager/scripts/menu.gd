extends Node2D

@onready var menu_music: AudioStreamPlayer = $MenuMusic
@onready var credits_background: TextureRect = $Credits

func _ready() -> void:
	credits_background.visible = false
	
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("fire")):
		credits_background.visible = false

func _on_play_button_pressed() -> void:
	print("LOAD GAME")
	get_tree().change_scene_to_file("res://game_manager/mini_game_manager.tscn")

func _on_bubble_ware_voices_finished() -> void:
	menu_music.play()

func _on_credits_button_pressed() -> void:
	if not credits_background.visible:
		credits_background.visible = true
