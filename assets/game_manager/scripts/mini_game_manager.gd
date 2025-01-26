class_name MiniGameManager
extends Node2D

const TIME_LIMIT: float = 5.0
const PREPARE_TIME: float = 1.0
const MINI_GAME_FOLDER_PATH: String = "res://minigame_scenes/"
const BUBBLEWARE_VOICE_CLIPS_PATH: String = "res://assets/audio/bubbleware_voices/"

const ANIM_INTRO = "intro_manager"
const ANIM_TRANSITION = "bubs_yeah"
const ANIM_INSTRUCTION = "show_instruction_banner"
const ANIM_END = "show_end_banner"

enum ManagerStates {
	INTRO,
	TRANSITIONING,
	PREPARING,
	PLAYING,
	ENDING,
}

var current_manager_state: ManagerStates = ManagerStates.INTRO 

@onready var mini_game_timer: Timer = $MiniGameTimer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var transition_animated_sprite: AnimatedSprite2D = $TransitionAnimatedSprite

## Overlay UI elements
@onready var overlay_mini_game: CanvasLayer = $MiniGameOverlay
@onready var timer_label: Label = $MiniGameOverlay/TimerLabel
@onready var instruction_label: Label = $MiniGameOverlay/InstructionBanner/InstructionLabel
@onready var instruction_banner: Control = $MiniGameOverlay/InstructionBanner

## Sounds and music
@onready var audio_mini_game_result: 	AudioStreamPlayer = $Audio_MiniGameResult
@onready var audio_mini_game_music: 	AudioStreamPlayer = $Audio_MiniGameMusic
@onready var audio_bubbleware: 			AudioStreamPlayer = $Audio_Bubbleware
@onready var audio_transition: 			AudioStreamPlayer = $Audio_Transition

# List of win/lost transition sounds
var audio_transition_win = [
	preload("res://assets/audio/cole wario excellent 1.wav"),
	preload("res://assets/audio/cole wario win 1.wav")
]
var audio_transition_lose = [
	preload("res://assets/audio/cole thwomp 1.wav"),
	preload("res://assets/audio/cole wario lose 1.wav"),
	preload("res://assets/audio/cole wario lose 2.wav")
]

# All bubble clips, pulled directly from the folder
var audio_bubbleware_list: Array


var rng = RandomNumberGenerator.new()

var current_mini_game: BaseMiniGame
var current_mini_game_resource: Resource # Next minigames are loaded during the TRANSITION state

var all_mini_game_names: PackedStringArray
var all_mini_game_count: int
var unplayed_mini_game_indexes: Array

var lives: int
var wins: int

@export
var minigame_name_override: String = "" #replace with a full name e.g. "meteor_mini_game.tscn"

var show_good_transition: bool = true

## Fired if the mini_game_timer runs out before the current_mini_game responds
## ATTENTION: Not currently used anywhere in the code
# signal mini_game_timeout

func cache_all_mini_game_names() -> void:
	var dir = DirAccess.open(MINI_GAME_FOLDER_PATH)
	if dir:
		all_mini_game_names = filter_mini_game_names(dir.get_files())
		all_mini_game_count = all_mini_game_names.size()
		unplayed_mini_game_indexes = range(all_mini_game_count)
		unplayed_mini_game_indexes.shuffle()
		for minigame_str in all_mini_game_names:
			print(minigame_str)
	else:
		print("ERROR: Cannot find MiniGame folder!")

func cache_all_bubbleware_clips() -> void:
	
	var dir = DirAccess.open(BUBBLEWARE_VOICE_CLIPS_PATH)
	if dir:
		var test_array = filter_bubbleware_voice_names(dir.get_files())
		audio_bubbleware_list = Array(test_array)
		print("Bubbleare voice clips: ")
		print(audio_bubbleware_list)
	else:
		print("ERROR: Cannot find Bubbleare voices folder!")
	

# Filters out any non-scene files from the Minigames folder
func filter_mini_game_names(names: PackedStringArray) -> PackedStringArray:
	if minigame_name_override != "":
		return PackedStringArray([minigame_name_override])
	
	var bad_indexes: Array[int]
	var index = 0
	for filename in names:
		var filetype = filename.get_slice(".",1)
		if(filetype != "tscn"):
			print("Removing " +filename)
			bad_indexes.append(index)
		index += 1
	for bad_index in bad_indexes:
		names.remove_at(bad_index)
	return names

# Filters out any non-scene files from the Minigames folder
func filter_bubbleware_voice_names(names: PackedStringArray) -> PackedStringArray:
	
	var good_names: Array[String]
	print("Filter Bubbleware Voice Names")
	for filename in names:
		print(filename)
		filename = sanitize_filename(filename) # This is a workaround for the build
		print("Sanitized name: " + filename)
		if(filename.ends_with("wav")):
			print("Adding " + filename)
			good_names.append(filename)
	return good_names

func sanitize_filename(filename: String) -> String:
	if(filename.ends_with(".import")): # and ResourceLoader.exists(filename.trim_suffix(".import"))):
		return filename.trim_suffix(".import")
	else:
		return filename

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Manager starts in the INTRO state
	mini_game_timer.wait_time = TIME_LIMIT
	overlay_mini_game.max_time = TIME_LIMIT
	overlay_mini_game.reset_lives()
	overlay_mini_game.visible = false
	instruction_banner.visible = false
	transition_animated_sprite.visible = false
	lives = 5
	wins = 0
	cache_all_mini_game_names()
	cache_all_bubbleware_clips()
	animation_player.play(ANIM_INTRO) # Start the Intro

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(current_manager_state == ManagerStates.PLAYING):
		update_timer()
		overlay_mini_game.adjust_time_bar_length(mini_game_timer.time_left)
	
func update_timer() -> void:
	set_timer_text(str((mini_game_timer.time_left + 1) as int))

func set_timer_text(time_text: String) -> void:
	timer_label.text = "TIME: " + time_text 

func pick_next_mini_game_name() -> String:
	if(unplayed_mini_game_indexes.is_empty()):
		unplayed_mini_game_indexes = range(all_mini_game_count)
		unplayed_mini_game_indexes.shuffle()
	
	var next_index = unplayed_mini_game_indexes.pop_back()
	#var next_index = rng.randi_range(0, all_mini_game_count - 1)
	return all_mini_game_names[next_index]

## Loads up the next randomly picked minigame in the background
func load_next_mini_game() -> void:
	if(current_mini_game != null):
		current_mini_game.queue_free() # Delete the previous minigame
		audio_mini_game_music.stop()
	
	var filepath = MINI_GAME_FOLDER_PATH + pick_next_mini_game_name()
	current_mini_game_resource = load(filepath)
	
## Instantiates the loaded minigame, and adds it to the manager
func create_next_mini_game() -> void:
	current_mini_game = current_mini_game_resource.instantiate() as BaseMiniGame
	current_mini_game.run_testing_mode = false
	overlay_mini_game.reset_time_bar()
	add_child(current_mini_game)
	current_mini_game.game_finished.connect(_on_mini_game_finished)
	current_mini_game.result_jingle.connect(_on_jingle_result)
	play_music(current_mini_game.minigame_music.pick_random())
	instruction_label.text = current_mini_game.instruction_text

## Gives control to the Player
func start_current_mini_game() -> void:
	instruction_banner.visible = false
	current_mini_game.start_playing_game()
	mini_game_timer.wait_time = TIME_LIMIT
	mini_game_timer.start()
	overlay_mini_game.start_bubble_popper_timer()

## Manages
func set_manager_state(new_state: ManagerStates) -> void:
	if(current_manager_state == new_state):
		return
	
	# ATTENTION: This is never used
	# var old_state = current_manager_state
	current_manager_state = new_state
	
	## On Start State
	match current_manager_state:
		ManagerStates.TRANSITIONING:
			timer_label.visible = false
			load_next_mini_game()
			play_transition_sprites(show_good_transition)
			animation_player.play(ANIM_TRANSITION)
		ManagerStates.PREPARING:
			set_timer_text(str(floor(TIME_LIMIT)))
			timer_label.visible = true
			create_next_mini_game()
			overlay_mini_game.visible = true
			animation_player.play(ANIM_INSTRUCTION)
			
			# Play bubbleware voice clip
			audio_bubbleware.stream = load(BUBBLEWARE_VOICE_CLIPS_PATH + audio_bubbleware_list.pick_random())
			audio_bubbleware.play()
		ManagerStates.PLAYING:
			start_current_mini_game()
		ManagerStates.ENDING:
			animation_player.play(ANIM_END)

func play_transition_sprites(show_good: bool) -> void:
	transition_animated_sprite.visible = true
	if(show_good):
		transition_animated_sprite.play("bubs_yeah")
		# TODO: show wins here
		# Need to check if the lose>win jingle is playing, and it to play rather than the transition on top of it
		audio_transition.stream = audio_transition_win.pick_random()
		audio_transition.play()
	else:
		## TODO Show life loss animation here
		transition_animated_sprite.play("bubs_no")
		audio_transition.stream = audio_transition_lose.pick_random()
		audio_transition.play()

func _on_animation_player_finished(anim_name: StringName) -> void:
	## On End State
	match anim_name:
		ANIM_TRANSITION:
			transition_animated_sprite.visible = false
			set_manager_state(ManagerStates.PREPARING)
		ANIM_INTRO,	ANIM_END:
			set_manager_state(ManagerStates.TRANSITIONING)
		ANIM_INSTRUCTION:
			set_manager_state(ManagerStates.PLAYING)

## The current minigame will either end when time runs out ...
func _on_mini_game_timer_timeout() -> void:
	set_timer_text("OUT")
	current_mini_game._on_timeout()

## ... or when the current_mini_game signals the Manager that the player reached a Win/Lose state
func _on_mini_game_finished(is_win: bool) -> void:
	mini_game_timer.stop()
	overlay_mini_game.stop_bubble_popper_timer()
	show_good_transition = is_win
	if (is_win == true):
		wins += 1
		instruction_label.text = "WINNER!"
	else:
		lose_life()
		instruction_label.text = "LOSER!"
	set_manager_state(ManagerStates.ENDING)

func lose_life() -> void:
	lives -= 1
	overlay_mini_game.remove_a_life()
	if lives <= 0:
		print("GAME OVER!")

# Plays a jingle when a game ends
func _on_jingle_result (jingle) -> void:
	
	# Cancel any currently playing result
	audio_mini_game_result.stop()
	audio_mini_game_music.stop()
	
	# Play jingle on result
	if jingle != null:
		audio_mini_game_result.stream = jingle
		audio_mini_game_result.play()
	
	pass

func play_music(music) -> void:
	
	if music != null:
		audio_mini_game_music.stop()
		audio_mini_game_music.stream = music
		audio_mini_game_music.play()
	
	pass
