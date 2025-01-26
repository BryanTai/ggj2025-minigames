@icon("res://assets/game_manager/BaseMiniGame.svg")
class_name BaseMiniGame extends Node2D

## A short description of the node will go here.
# This class handles the base behaviour of all MiniGames
# All MiniGames should extend this class
# For examples of how to create a MiniGame, see the Template scripts
 
## A longer description of the BaseMiniGame node will go here.

## A signal that should be emitted when the mini-game is finished, along with a 
## [bool] parameter specifying if the player has won ([code]TRUE[/code]) or lost 
## ([code]FALSE[/code]).
signal game_finished(is_win: bool)

signal result_jingle(result)	# Pass along a pre-loaded audio jingle asset to play for the result
signal minigame_music_signal(music)	# Pass along a pre-loaded music asset to play during the minigame

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

## Set this flag to "false" in your MiniGame if you don't want everything disabled outside of the PLAYING state
var disable_minigame_during_intro_and_outro = true

## Sounds and music overrides for minigames. 
# To set your own music, drag and drop your files onto the "BaseMiniGame" script slots of the same names in the INSPECTOR panel
# You can set your own using these variables, otherise it will use the generic ones
# The "lose_then_win" is played when a game is lost but then won shortly after. Cuts out any previous result sfx
@export var minigame_sfx_win: Array[AudioStreamWAV] = [preload("res://assets/audio/win_sfx_1.wav")]
@export var minigame_sfx_lose: Array[AudioStreamWAV] = [preload("res://assets/audio/lose_sfx_1.wav")]
@export var minigame_sfx_lose_then_win: Array[AudioStreamWAV] = [preload("res://assets/audio/cole wario you lose you win 1.wav")]
@export var minigame_music: Array[AudioStreamWAV] = [
	preload("res://assets/audio/loop_1_125BPM.wav"),
	preload("res://assets/audio/loop_1_135BPM.wav"),
	preload("res://assets/audio/loop_1_145BPM.wav")
]

## This will automatically be disabled by the mini_game_manager
var run_testing_mode = true
var test_label : Label
var test_playing_timer : Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_start_preparing_state()
	start_test_intro_timer()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_state_machine(delta)

## This will begin the actual Minigame specified in the [enum MiniGameState]'s  
## [code]PLAYING[/code] state.
func start_playing_game() -> void:
	set_mini_game_state(MiniGameState.PLAYING)

## TESTING FUNCTIONS
# These will only work if the MiniGame is tested individually without the MiniGameManager

## Creates a Label and Timer to mimic the Introduction sequence
func start_test_intro_timer() -> void:
	if(run_testing_mode):
		print("Creating a test timer!")
		test_label = Label.new()
		test_label.text = instruction_text
		test_label.scale = Vector2(10, 10)
		add_child(test_label)

		var test_intro_timer = Timer.new()
		test_intro_timer.wait_time = 1
		test_intro_timer.timeout.connect(start_playing_game)
		test_intro_timer.one_shot = true
		test_intro_timer.process_mode = Node.PROCESS_MODE_ALWAYS
		add_child(test_intro_timer)
		test_intro_timer.start()

## Creates a timer to mimic the PLAYING countdown
func start_test_playing_timer() -> void:
	if(run_testing_mode):
		test_playing_timer = Timer.new()
		test_playing_timer.wait_time = 5
		test_playing_timer.one_shot = true
		test_playing_timer.timeout.connect(start_playing_game)
		add_child(test_playing_timer)
		test_playing_timer.start()

## Update the test label with the current time
func process_test_playing_timer() -> void:
	if(run_testing_mode):
		if(test_playing_timer.is_stopped()):
			test_label.text = "0"
		else:
			var display_seconds = (test_playing_timer.time_left + 1) as int
			test_label.text = str(display_seconds)

# ENDING THE GAME

## A signal from the MiniGameManager that time has run out.
## Can be overridden if the MiniGame has different criteria, where surviving for
## the duration of the timer is the WIN condition, for example.
func _on_timeout() -> void:
	trigger_game_lose()

## Notifies the Game Manager that the WIN condition has been met.
func trigger_game_win() -> void:
	game_finished.emit(true)
	
	# Play win jingle
	# Favor overrides, otherwise use generics
	var _sound_to_play = null
	if current_state == MiniGameState.LOSE:	# Game was lost but now we won
		_sound_to_play = minigame_sfx_lose_then_win.pick_random()
	else:
		_sound_to_play = minigame_sfx_win.pick_random()
	
	result_jingle.emit(_sound_to_play)
	set_mini_game_state(MiniGameState.WIN)

## Notifies the Game Manager that the WIN condition was [b]NOT[/b] met.
func trigger_game_lose() -> void:
	game_finished.emit(false)
	result_jingle.emit(minigame_sfx_lose.pick_random())
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
			start_test_playing_timer()
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
			process_test_playing_timer()
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

## Called once when entering the PREPARING state (e.g. once the minigame is loaded)
## almost equivalent to _ready()
func _on_start_preparing_state() -> void:
	# This disables every Node in the mini game
	if(disable_minigame_during_intro_and_outro):
		process_mode = Node.PROCESS_MODE_DISABLED

## Called every frame while minigame is in the PREPARING state. This method should
## contain any special code beyond the default instructions BEFORE the game starts.
## [br]
## e.g. Kirby crashing into the stage on his shooting star.
func _process_preparing_state(_delta: float) -> void:
	pass

## Called once when the PREPARING state ends. Could be used to trigger some animation
## to signal that the mini-game has started.
## [br]
## e.g. a gun firing off and then disappearing.
func _on_end_preparing_state() -> void:
	# Once the instruction banner goes away, enable all the nodes in the game
	if(disable_minigame_during_intro_and_outro):
		process_mode = Node.PROCESS_MODE_INHERIT

# PLAYING STATE

## Called once when entering the PLAYING state (e.g. once the player gains control)
func _on_start_playing_state() -> void:
	pass

## Called every frame while minigame is in the PLAYING state. This is where the 
## meat of the mini-game should be!
func _process_playing_state(_delta: float) -> void:
	pass

## Called once when the PLAYING state ends. You could trigger any number of things
## here before the actual WIN/LOSE window appears.
## [br]
## e.g. your running character screeches to a halt over a short distance.
func _on_end_playing_state() -> void:
	# Disables every Node in the mini game on Win or Lose
	if(disable_minigame_during_intro_and_outro):
		process_mode = Node.PROCESS_MODE_DISABLED

# WIN STATE

## Called once when entering the WIN state.
func _on_start_win_state() -> void:
	pass

## Called every frame while minigame is in the WIN state.
func _process_win_state(_delta: float) -> void:
	pass

# LOSE STATE

## Called once when entering the LOSE state.
func _on_start_lose_state() -> void:
	pass

## Called every frame while minigame is in the LOSE state.
func _process_lose_state(_delta: float) -> void:
	pass
