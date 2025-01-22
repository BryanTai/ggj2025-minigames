class_name BaseMiniGame
extends Node2D

signal game_finished(is_win: bool)

enum MiniGameState { 
	PREPARING, ## Game loads in, player has no control, instructions displayed
	PLAYING, ## Player has control
	WIN, ## Player reaches the win condition
	LOSE ## Either the player has reached a losing condition or has run out of time
}

@export var instruction_text: String = "WIN" # Replace this text in the Inspector!

var current_state: MiniGameState = MiniGameState.PREPARING

var disable_minigame_during_intro_and_outro = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_start_preparing_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_state_machine(delta)

func start_playing_game() -> void:
	set_mini_game_state(MiniGameState.PLAYING)

### ENDING THE GAME

# A signal from the MiniGameManager that time has run out
# Can be overridden if the MiniGame has different criteria
func _on_timeout() -> void:
	trigger_game_lose()

# Call when win condition is met! Signals the Game Manager
func trigger_game_win() -> void:
	game_finished.emit(true)
	set_mini_game_state(MiniGameState.WIN)

#Call when lose condition is met. Signals the Game Manager
func trigger_game_lose() -> void:
	game_finished.emit(false)
	set_mini_game_state(MiniGameState.LOSE)

### STATE MACHINE FUNCTIONS

# Switch the current state
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

# Update the minigame based on the current state
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

### STATE SPECIFIC FUNCTIONS
# All the functions below this line will handle the different state events
# They are intended to be overridden by new MiniGame scripts!

## PREPARE STATE

func _on_start_preparing_state() -> void:
	# This disables every Node in the mini game
	if(disable_minigame_during_intro_and_outro):
		process_mode = Node.PROCESS_MODE_DISABLED

# Called every frame while minigame is in the PREPARING state
func _process_preparing_state(delta: float) -> void:
	pass

# Called once when the PREPARING state ends
func _on_end_preparing_state() -> void:
	# Once the instruction banner goes away, enable all the nodes in the game
	if(disable_minigame_during_intro_and_outro):
		process_mode = Node.PROCESS_MODE_INHERIT

## PLAYING STATE

# Called once when entering the PLAYING state (e.g. once the player gains control)
func _on_start_playing_state() -> void:
	pass

# Called every frame while minigame is in the PLAYING state
func _process_playing_state(delta: float) -> void:
	pass

# Called once when the PLAYING state ends (e.g. Win or Lose)
func _on_end_playing_state() -> void:
	# Disables every Node in the mini game on Win or Lose
	if(disable_minigame_during_intro_and_outro):
		process_mode = Node.PROCESS_MODE_DISABLED

## WIN STATE

# Called once when entering the WIN state
func _on_start_win_state() -> void:
	pass

# Called every frame while minigame is in the WIN state
func _process_win_state(delta: float) -> void:
	pass

## LOSE STATE

# Called once when entering the LOSE state
func _on_start_lose_state() -> void:
	pass

# Called every frame while minigame is in the LOSE state
func _process_lose_state(delta: float) -> void:
	pass
