class_name RunnerMiniGame
extends BaseMiniGame

@onready var finish_line: AnimatedSprite2D = $FinishLine
@onready var runner: AnimatedSprite2D = $Runner

@export var SPEED: int = 180
@export var SLOW_SPEED: int = 50
@export var FINISH_LINE_X_POS: int = 800
@export var instruction: String = "Run!"
@export var direction_input: String = "move_right"


func move_runner(speed_delta: float) -> void:
	var old_pos = runner.position
	runner.set_position(Vector2(old_pos.x + speed_delta, old_pos.y))

### STATE SPECIFIC FUNCTIONS
## These are intended to be overridden!
## You probably won't need all of them so feel free to delete unused ones

## PREPARE STATE

func _on_start_preparing_state() -> void:
	disable_minigame_during_intro_and_outro = false
	instruction_text = instruction
	finish_line.play("intact")
	runner.play("idle")

## PLAYING STATE

func _on_start_playing_state() -> void:
	runner.play("idle")

func _process_playing_state(delta: float) -> void:
	if(Input.get_action_strength(direction_input) > 0 or Input.get_action_strength("fire") > 0):
		move_runner(SPEED * delta)
		runner.play("running")
	else:
		runner.play("idle")
		
	if(direction_input == "move_right" and runner.position.x > FINISH_LINE_X_POS):
		trigger_game_win()
	if(direction_input == "move_left" and runner.position.x < FINISH_LINE_X_POS):
		trigger_game_win()

## WIN STATE

func _on_start_win_state() -> void:
	finish_line.play("broken")
	runner.play("win")
	
func _process_win_state(delta: float) -> void:
	move_runner(SLOW_SPEED * delta)

## LOSE STATE

func _on_start_lose_state() -> void:
	runner.play("lose")
