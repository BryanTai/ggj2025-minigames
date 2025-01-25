extends BaseMiniGame

@onready var finish_line: AnimatedSprite2D = $FinishLine
@onready var runner: AnimatedSprite2D = $Runner
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const SPEED: int = 180
const SLOW_SPEED: int = 50
const FINISH_LINE_X_POS: int = 900

func move_runner(speed_delta: float) -> void:
	var old_pos = runner.position
	runner.set_position(Vector2(old_pos.x + speed_delta, old_pos.y))

### STATE SPECIFIC FUNCTIONS
## These are intended to be overridden!
## You probably won't need all of them so feel free to delete unused ones

## PREPARE STATE

func _on_start_preparing_state() -> void:
	disable_minigame_during_intro_and_outro = false
	instruction_text = "GET DOWN AND RUN!"
	finish_line.play("intact")
	runner.play("idle")
	audio_stream_player.play()

## PLAYING STATE

func _process_playing_state(delta: float) -> void:
	if(Input.get_action_strength("move_right") > 0 or Input.get_action_strength("fire") > 0):
		move_runner(SPEED * delta)
		runner.play("running")
	else:
		runner.play("idle")
		
	if(runner.position.x > FINISH_LINE_X_POS):
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
