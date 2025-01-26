extends BaseMiniGame

var is_aligned := false
@onready var the_straw: CharacterBody2D = $TheStraw

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instruction_text = "STAB THE CENTER!" # This text will display during the PREPARING phase
	the_straw.stabbed_in_the_center.connect(func ()-> void: is_aligned = true)
	super() ## Do not remove this super() call!
	## Put any logic you'd like to happen at the beginning of your minigame here!

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta) ## This line will process the State machine! DO NOT REMOVE
	## Use this _process function for your game logic!
	
	


# A signal from the MiniGameManager that time has run out
## TODO: Override this function if your MiniGame checks the win condition on TimeOut
#func _on_timeout() -> void:
#	trigger_game_lose()


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
#func _on_start_playing_state() -> void:
#	pass

# Called every frame while minigame is in the PLAYING state
#func _process_playing_state(delta: float) -> void:
	#pass

# Called once when the PLAYING state ends (e.g. Win or Lose)
func _on_end_playing_state() -> void:
	disable_minigame_during_intro_and_outro = false
	super()

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

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if is_aligned:
		the_straw.display_win_animation()
		trigger_game_win()
	else:
		the_straw.display_lose_animation()
		trigger_game_lose()
