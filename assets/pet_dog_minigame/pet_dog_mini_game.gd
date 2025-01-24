extends BaseMiniGame

@onready var player: Area2D = $Player
@onready var goal: Area2D = $Goal
@onready var dog_sprite: AnimatedSprite2D = $Goal/DogSprite
@onready var hand_sprite: Sprite2D = $Player/HandSprite

@export var player_speed: int = 200

func _on_start_preparing_state() -> void:
	goal.area_entered.connect(on_goal_collided)
	disable_minigame_during_intro_and_outro = false
	instruction_text = "Pet!"
	dog_sprite.play("idle")

func _process_playing_state(delta: float) -> void:
	super(delta)
	
	# This handles Horizontal movement
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	if(horizontal_direction != 0):
		var old_pos = player.position
		var new_x = old_pos.x + (horizontal_direction * player_speed * delta);
		player.set_position(Vector2(new_x, old_pos.y))
	
	# This handles Vertical movement
	var vertical_direction := Input.get_axis("move_up", "move_down")
	if(vertical_direction != 0):
		var old_pos = player.position
		var new_y = old_pos.y + (vertical_direction * player_speed * delta);
		player.set_position(Vector2(old_pos.x, new_y))

func on_goal_collided(area: Area2D) -> void:
	trigger_game_win()
	
func _on_start_win_state() -> void:
	hand_sprite.visible = false
	dog_sprite.play("pet")

func _on_start_lose_state() -> void:
	dog_sprite.play("sad")
