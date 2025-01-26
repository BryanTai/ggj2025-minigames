## TL;DR What You Need To Do:
# 1) Create a new MiniGame scene and script
# 2A) If you're starting from scratch, copy/paste the contents of this file into your minigame script to get started
# 2B) If you're importing a game, make sure the top of your script has the "extends BaseMiniGame" line
# 3) Make sure _ready() and _process() have the "super()" call inside their bodies
# 4) Set the intro text with "instruction_text = "Replace me with instructions!" "
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

@onready var bubble: Sprite2D = $Bubble
@onready var bubs: Sprite2D = $Bubs
@onready var popped_particle: GPUParticles2D = $PoppedParticle
@onready var balloon_blow_sfx: AudioStreamPlayer = $BalloonBlow
@onready var balloon_pop_sfx: AudioStreamPlayer = $BalloonPop
@onready var air_leak_sfx: AudioStreamPlayer = $AirLeak

func _init() -> void:
	disable_minigame_during_intro_and_outro = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instruction_text = "Blow!" # This text will display during the PREPARING phase
	super() ## Do not remove this super() call!
	## Put any logic you'd like to happen at the beginning of your minigame here!

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta) ## This line will process the State machine! DO NOT REMOVE
	## Use this _process function for your game logic!
	
	# Here's an example
	### TODO: Use these 2 functions to trigger WIN or LOSE
	#if(instruction_text == "Replace me with instructions!"):
		#trigger_game_lose()
	#else:
		#trigger_game_win()


# A signal from the MiniGameManager that time has run out
## TODO: Override this function if your MiniGame checks the win condition on TimeOut
func _on_timeout() -> void:
	print(bubble.scale.x)
	if bubble.scale.x > 1:
		trigger_game_win()
	else:
		trigger_game_lose()


### STATE SPECIFIC FUNCTIONS
# Add your game logic to these functions! See README at the top of this file for more info
# You probably won't need all of them so feel free to delete unused ones

## PREPARE STATE

# Called at the beginning of the game
#func _on_start_preparing_state() -> void:
#	# By default, this disables all Nodes in the minigame. Overwrite this if you want something else
#	pass

# Called every frame while minigame is in the PREPARING state
#func _process_preparing_state(delta: float) -> void:
#	pass

# Called once when the PREPARING state ends
#func _on_end_preparing_state() -> void:
#	# By default, this enables all disabled Nodes in the minigame
#	pass

## PLAYING STATE

# Called once when entering the PLAYING state (e.g. once the player gains control)
func _on_start_playing_state() -> void:
	air_leak_sfx.play()
	pass

var mouth_timer_counter: float = 0
const MOUTH_MAX_TIME: float = 0.25
const max_bubble_scale: float = 3.0
# Called every frame while minigame is in the PLAYING state
func _process_playing_state(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		bubs.frame = 1
		mouth_timer_counter = MOUTH_MAX_TIME
		bubble.scale *= 1.2
		balloon_blow_sfx.pitch_scale = lerp(0.8, 1.2, bubble.scale.x / max_bubble_scale)
		balloon_blow_sfx.play()
	else:
		bubble.scale *= pow(0.7, delta) # Make this Frame independent.
	
	if mouth_timer_counter > 0:
		mouth_timer_counter -= delta
		if mouth_timer_counter <= 0:
			bubs.frame = 0
	
	# Modulate the bubble color as it get closer to the targeted value.
	var size_difference: float = 1 - clamp(max_bubble_scale - bubble.scale.x, 0, 1)
	bubble.modulate = lerp(Color.WHITE, Color.ORANGE, pow(size_difference, 1.5))
	
	# Pop the bubble if it's too big.
	if (bubble.scale.x > max_bubble_scale):
		balloon_pop_sfx.play()
		air_leak_sfx.stop()
		popped_particle.position = bubble.position
		popped_particle.modulate = Color.ORANGE
		popped_particle.emitting = true
		bubble.visible = false
		trigger_game_lose()

# Called once when the PLAYING state ends (e.g. Win or Lose)
func _on_end_playing_state() -> void:
	bubs.frame = 0
	pass

## WIN STATE

# Called once when entering the WIN state
func _on_start_win_state() -> void:
	air_leak_sfx.stop()
	pass

var float_speed = 500

# Called every frame while minigame is in the WIN state
func _process_win_state(delta: float) -> void:
	bubble.position.y -= float_speed * delta
	bubs.position.y -= float_speed * delta
	float_speed += 1000 * delta
	pass

## LOSE STATE

# Called once when entering the LOSE state
#func _on_start_lose_state() -> void:
#	pass

var lose_modulate_timer: float = 0
# Called every frame while minigame is in the LOSE state
func _process_lose_state(delta: float) -> void:
	lose_modulate_timer += delta
	popped_particle.modulate = lerp(Color.ORANGE, Color.WHITE, sqrt(lose_modulate_timer))
	air_leak_sfx.volume_db = 5
	air_leak_sfx.pitch_scale = 1.2
	bubble.scale *= pow(0.1, delta)
	pass
