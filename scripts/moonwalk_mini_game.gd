extends BaseMiniGame

@onready var finish_line: AnimatedSprite2D = $FinishLine
@onready var runner: AnimatedSprite2D = $Runner

const SPEED: int = -200
const SLOW_SPEED: int = -50
const FINISH_LINE_X_POS: int = 270

func _ready() -> void:
	super()
	instruction_text = "Moonwalk!"
	## Put any logic you'd like to happen at the beginning of your minigame here!
	finish_line.play("intact")
	runner.play("lose")

func _process(delta: float) -> void:
	super(delta) ## This line will process the State machine!
	## Use this _process function for things that don't care about the state
	
func move_runner(speed_delta: float) -> void:
	var old_pos = runner.position
	runner.set_position(Vector2(old_pos.x + speed_delta, old_pos.y))

### STATE SPECIFIC FUNCTIONS
## These are intended to be overridden!
## You probably won't need all of them so feel free to delete unused ones

## PREPARE STATE

# Didn't need them!

## PLAYING STATE

func _on_start_playing_state() -> void:
	runner.play("idle")

func _process_playing_state(delta: float) -> void:
	if(Input.get_action_strength("move_left") > 0):
		move_runner(SPEED * delta)
		runner.play("running")
	else:
		runner.play("idle")
		
	if(runner.position.x < FINISH_LINE_X_POS):
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
