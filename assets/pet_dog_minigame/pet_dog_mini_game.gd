extends BaseMiniGame

@onready var player_2d: Player2D = $Player2D
@onready var goal: Area2D = $Goal
@onready var dog_sprite: AnimatedSprite2D = $Goal/DogSprite
@onready var hand_sprite: Sprite2D = $Player2D/Sprite2D

@export var player_speed: int = 200

func _on_start_preparing_state() -> void:
	goal.area_entered.connect(on_goal_collided)
	disable_minigame_during_intro_and_outro = false
	instruction_text = "Pet!"
	dog_sprite.play("idle")
	player_2d.process_mode = Node.PROCESS_MODE_DISABLED

func _on_start_playing_state() -> void:
	player_2d.process_mode = Node.PROCESS_MODE_INHERIT

func on_goal_collided(area: Area2D) -> void:
	trigger_game_win()
	
func _on_start_win_state() -> void:
	hand_sprite.visible = false
	dog_sprite.play("pet")

func _on_start_lose_state() -> void:
	player_2d.process_mode = Node.PROCESS_MODE_DISABLED
	dog_sprite.play("sad")
