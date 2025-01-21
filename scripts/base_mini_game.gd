@icon("res://sprites/BaseMiniGame.svg")
class_name BaseMiniGame extends Node2D

## A short description of the node will go here.
 
## A longer description of the BaseMiniGame node will go here.

## A signal that should be emitted when the mini-game is finished, along with a 
## [bool] parameter specifying if the player has won ([code]TRUE[/code]) or lost 
## ([code]FALSE[/code]).
signal game_finished(is_win: bool)

## These are the numerous states we'll use.
enum MiniGameState { 
	PREPARING, ## The state that the minigame first loads in, shows the instructions.
	PLAYING, ## The state that contains the actual minigame.
	WIN, ## The state when a player achieves the [color=lime]WIN[/color] condition.
	LOSE ## The state when the player has [color=red]LOST[/color] or run out of time.
}

## The text that will be displayed during the [code]PREPARING[/code] state.
@export var instruction_text: String = "WIN" # Replace this text in the Inspector!

## The current state of the minigame. This will always start with [code]PREPARING[/code].
var current_state: MiniGameState = MiniGameState.PREPARING

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_state_machine(delta)

## This will begin the actual Minigame specified in the [enum MiniGameState]'s  
## [code]PLAYING[/code] state.
func start_playing_game() -> void:
	set_mini_game_state(MiniGameState.PLAYING)

# ENDING THE GAME

## A signal from the MiniGameManager that time has run out.
## Can be overridden if the MiniGame has different criteria, where surviving for
## the duration of the timer is the WIN condition, for example.
func _on_timeout() -> void:
	trigger_game_lose()

## Notifies the Game Manager that the WIN condition has been met.
func trigger_game_win() -> void:
	game_finished.emit(true)
	set_mini_game_state(MiniGameState.WIN)

## Notifies the Game Manager that the WIN condition was [b]NOT[/b] met.
func trigger_game_lose() -> void:
	game_finished.emit(false)
	set_mini_game_state(MiniGameState.LOSE)

# STATE MACHINE FUNCTIONS

## Switches the current state
func set_mini_game_state(new_state: MiniGameState) -> void:
	if(current_state == new_state):
		return

	var old_state = current_state
	current_state = new_state
	
	match old_state:
		MiniGameState.PREPARING:
			_on_end_preparing_state()
		MiniGameState.PLAYING:
			_on_end_playing_state()
	
	match current_state:
		MiniGameState.PLAYING:
			_on_start_playing_state()
		MiniGameState.WIN:
			_on_start_win_state()
		MiniGameState.LOSE:
			_on_start_lose_state()

## Update the minigame based on the current state
func process_state_machine(delta: float) -> void:
	match(current_state):
		MiniGameState.PREPARING:
			_process_preparing_state(delta)
		MiniGameState.PLAYING:
			_process_playing_state(delta)
		MiniGameState.WIN:
			_process_win_state(delta)
		MiniGameState.LOSE:
			_process_lose_state(delta)

# STATE SPECIFIC FUNCTIONS
#
# NOTE: All the functions below this line will handle the different state events
# They are intended to be overridden by new MiniGame scripts!

# PREPARE STATE

## Called every frame while minigame is in the PREPARING state. This method should
## contain any special code beyond the default instructions BEFORE the game starts.
## [br]
## e.g. Kirby crashing into the stage on his shooting star.
func _process_preparing_state(delta: float) -> void:
	pass

## Called once when the PREPARING state ends. Could be used to trigger some animation
## to signal that the mini-game has started.
## [br]
## e.g. a gun firing off and then disappearing.
func _on_end_preparing_state() -> void:
	pass

# PLAYING STATE

## Called once when entering the PLAYING state (e.g. once the player gains control)
func _on_start_playing_state() -> void:
	pass

## Called every frame while minigame is in the PLAYING state. This is where the 
## meat of the mini-game should be!
func _process_playing_state(delta: float) -> void:
	pass

## Called once when the PLAYING state ends. You could trigger any number of things
## here before the actual WIN/LOSE window appears.
## [br]
## e.g. your running character screeches to a halt over a short distance.
func _on_end_playing_state() -> void:
	pass

# WIN STATE

## Called once when entering the WIN state.
func _on_start_win_state() -> void:
	pass

## Called every frame while minigame is in the WIN state.
func _process_win_state(delta: float) -> void:
	pass

# LOSE STATE

## Called once when entering the LOSE state.
func _on_start_lose_state() -> void:
	pass

## Called every frame while minigame is in the LOSE state.
func _process_lose_state(delta: float) -> void:
	pass
