### README -bryan 

## TL;DR What You Need To Do:
# 5) Trigger the Win and Lose with "trigger_game_lose()" and "trigger_game_win()"
# 6A) If the MiniGame has no logic that runs before or after the PLAYING state, add your code into _ready() and _process() as normal 
#	By default, the MiniGame will automatically disable all nodes at the beginning and enable them once the player has control
#	This can be disabled using the "disable_minigame_during_intro_and_outro" flag
# 6B) if you want the game to do stuff before the timer starts or after the game ends, read my notes about STATES below

## MINIGAME STATES
# There are 4 states that a Mini Game can be in:
#	1) PREPARING,	Game loads in, player has no control, instructions displayed
#	2) PLAYING, 	Player has control
#	3A) WIN, 		Player reaches the win condition, no longer has control
#	3B) LOSE, 		Either the player has reached a losing condition or has run out of time, no longer has control
## The MiniGame can only be in 1 state at a time
# See "BaseMiniGame.MiniGameState" and "BaseMiniGame.current_state"

## SWITCHING STATES
# Every State has an Event Function for Start, Process, and End
# The Process event for "current_state" will trigger every frame (similar to Unity's Update() function)
# When the "current_state" is changed from an old state to a new state, it will trigger the Start event of the new state
# On the same frame, the End event of the old state will also trigger
## BaseMiniGame and MiniGameManager will automatically handle switching states and TimeOuts
## New MiniGame scripts don't need to worry about implementing any of this

## STATE FUNCTIONS
# BaseMiniGame has functions for each state that are designed to be overridden:
# 	"_on_start_XXX_state"
# 	"_on_end_XXX_state"
# 	"_process_XXX_state"
## You can add your game logic into these functions (found at the bottom of this file) to limit which state they get called in
# By default, the MiniGame will disable all nodes during any state that isn't PLAYING
# as a result, you can use the _process() function as "_process_playing_state()" if you don't care about doing anything in PREPARING, WIN, or LOSE

## TRIGGERING WIN/LOSE
# There are two custom functions that will signal to the Manager that the game is over:
#	trigger_game_lose()
#	trigger_game_win()
## You need to add these functions into your minigame script for the game to end properly
# Additionally, the MiniGameManager will signal the MiniGame when the Timer runs out using this function:
#	_on_time_out()
# By default, this will trigger the LOSE state
## You can override this function if the MiniGame makes a check for win/lose at timeout

extends BaseMiniGame

var label: Label
var cup: Node2D
var straw: Node2D
var bubbles: Node2D
var milk: Node2D

var bubbles_initial_pos: Vector2
var milk_initial_pos: Vector2
var bubbles_target_pos: Vector2
var milk_target_pos: Vector2

var filled_amount: float = 0.0

const FILL_RATE: float = 50.0
const DRAIN_RATE: float = 15.0
const REQUIRED_FILL_TO_WIN: float = 100.0
const MILK_MOVE_AMOUNT: float = 250.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instruction_text = "Froth!" # This text will display during the PREPARING phase
	super() ## Do not remove this super() call!
	
	label = find_child("Label")
	cup = find_child("Cup")
	straw = find_child("Straw") 
	bubbles = find_child("Bubbles")
	milk = find_child("Milk")
	
	bubbles_initial_pos = bubbles.position
	milk_initial_pos = milk.position
	bubbles_target_pos = bubbles.position - Vector2(0, MILK_MOVE_AMOUNT)
	milk_target_pos = milk.position - Vector2(0, MILK_MOVE_AMOUNT)
	
	print(bubbles_initial_pos, milk_initial_pos, bubbles_target_pos, milk_target_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta) ## This line will process the State machine! DO NOT REMOVE
	## Use this _process function for your game logic!
	
	if current_state != MiniGameState.PLAYING:
		return
	
	if Input.is_action_pressed("fire"):
		bubbles.visible = true
		filled_amount += FILL_RATE * delta
	else:
		bubbles.visible = false
		filled_amount -= DRAIN_RATE * delta

	if filled_amount <= 0:
		filled_amount = 0
	elif filled_amount >= REQUIRED_FILL_TO_WIN:
		filled_amount = REQUIRED_FILL_TO_WIN
	
	var alpha = filled_amount / REQUIRED_FILL_TO_WIN
	milk.position = milk_initial_pos.lerp(milk_target_pos, alpha)
	bubbles.position = bubbles_initial_pos.lerp(bubbles_target_pos, alpha)  
	
	label.text = "%f" % filled_amount
	
	if filled_amount >= REQUIRED_FILL_TO_WIN:
		trigger_game_win()

# A signal from the MiniGameManager that time has run out
func _on_timeout() -> void:
	trigger_game_lose()


### STATE SPECIFIC FUNCTIONS
# Add your game logic to these functions! See README at the top of this file for more info
# You probably won't need all of them so feel free to delete unused ones

## PREPARE STATE

# Called at the beginning of the game
func _on_start_preparing_state() -> void:
	# override base behavior which disables all the nodes
	pass

# Called every frame while minigame is in the PREPARING state
#func _process_preparing_state(delta: float) -> void:
#	pass

# Called once when the PREPARING state ends
func _on_end_preparing_state() -> void:
#	# override base behavior which enables all disabled Nodes in the minigame
	pass

## PLAYING STATE

# Called once when entering the PLAYING state (e.g. once the player gains control)
#func _on_start_playing_state() -> void:
#	pass

# Called every frame while minigame is in the PLAYING state
#func _process_playing_state(delta: float) -> void:
	#pass

# Called once when the PLAYING state ends (e.g. Win or Lose)
#func _on_end_playing_state() -> void:
#	pass

## WIN STATE

# Called once when entering the WIN state
#func _on_start_win_state() -> void:
#	pass

# Called every frame while minigame is in the WIN state
#func _process_win_state(delta: float) -> void:
#	pass

## LOSE STATE

# Called once when entering the LOSE state
#func _on_start_lose_state() -> void:
#	pass

# Called every frame while minigame is in the LOSE state
#func _process_lose_state(delta: float) -> void:
#	pass
