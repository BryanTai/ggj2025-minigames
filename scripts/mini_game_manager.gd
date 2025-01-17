class_name MiniGameManager
extends Node2D

const TIME_LIMIT: float = 5.0
const PREPARE_TIME: float = 1.0
const MINI_GAME_FOLDER_PATH: String = "res://scenes/minigames/"

const ANIM_INTRO = "intro_manager"
const ANIM_TRANSITION = "transition_mini_game"
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

## Overlay UI elements
@onready var overlay_mini_game: CanvasLayer = $MiniGameOverlay
@onready var timer_label: Label = $MiniGameOverlay/TimerLabel
@onready var instruction_label: Label = $MiniGameOverlay/InstructionBanner/InstructionLabel
@onready var instruction_banner: Control = $MiniGameOverlay/InstructionBanner

var rng = RandomNumberGenerator.new()

var current_mini_game: BaseMiniGame
var current_mini_game_resource: Resource # Next minigames are loaded during the TRANSITION state

var all_mini_game_names: PackedStringArray
var all_mini_game_count: int

## Fired if the mini_game_timer runs out before the current_mini_game responds
signal mini_game_timeout

func cache_all_mini_game_names() -> void:
	var dir = DirAccess.open(MINI_GAME_FOLDER_PATH)
	if dir:
		all_mini_game_names = dir.get_files()
		all_mini_game_count = all_mini_game_names.size()
		#for str in all_mini_game_names:
		#	print(str)
	else:
		print("ERROR: Cannot find MiniGame folder!")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Manager starts in the INTRO state
	mini_game_timer.wait_time = TIME_LIMIT
	overlay_mini_game.visible = false
	instruction_banner.visible = false
	cache_all_mini_game_names()
	animation_player.play(ANIM_INTRO) # Start the Intro

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(current_manager_state == ManagerStates.PLAYING):
		update_timer()
	
func update_timer() -> void:
	timer_label.text = "TIME: " + str((mini_game_timer.time_left + 1) as int)
	
func pick_next_mini_game_name() -> String:
	#TODO Once we have more minigames, create a buffer Queue to reduce chances of repeats
	var next_index = rng.randi_range(0, all_mini_game_count - 1)
	return all_mini_game_names[next_index]

## Loads up the next randomly picked minigame in the background
func load_next_mini_game() -> void:
	if(current_mini_game != null):
		current_mini_game.queue_free() # Delete the previous minigame
	
	var filepath = MINI_GAME_FOLDER_PATH + pick_next_mini_game_name()
	current_mini_game_resource = load(filepath)
	
## Instantiates the loaded minigame, and adds it to the manager
func create_next_mini_game() -> void:
	current_mini_game = current_mini_game_resource.instantiate() as BaseMiniGame
	add_child(current_mini_game)
	current_mini_game.game_finished.connect(_on_mini_game_finished)
	instruction_label.text = current_mini_game.instruction_text

## Gives control to the Player
func start_current_mini_game() -> void:
	instruction_banner.visible = false
	current_mini_game.start_playing_game()
	mini_game_timer.wait_time = TIME_LIMIT
	mini_game_timer.start()

func set_manager_state(new_state: ManagerStates) -> void:
	if(current_manager_state == new_state):
		return
	
	var old_state = current_manager_state
	current_manager_state = new_state
	
	## On Start State
	match current_manager_state:
		ManagerStates.TRANSITIONING:
			load_next_mini_game()
			animation_player.play(ANIM_TRANSITION)
		ManagerStates.PREPARING:
			create_next_mini_game()
			overlay_mini_game.visible = true
			animation_player.play(ANIM_INSTRUCTION)
		ManagerStates.PLAYING:
			start_current_mini_game()

func _on_animation_player_finished(anim_name: StringName) -> void:
	#On End State
	match anim_name:
		ANIM_TRANSITION:
			set_manager_state(ManagerStates.PREPARING)
		ANIM_INTRO,	ANIM_END:
			set_manager_state(ManagerStates.TRANSITIONING)
		ANIM_INSTRUCTION:
			set_manager_state(ManagerStates.PLAYING)

## The current minigame will either end when time runs out ...
func _on_mini_game_timer_timeout() -> void:
	timer_label.text = "TIME: OUT"
	current_mini_game.trigger_game_lose()

## ... or when the current_mini_game signals the Manager that the player reached a Win/Lose state
func _on_mini_game_finished(is_win: bool) -> void:
	mini_game_timer.stop()
	var new_banner_text: String
	if (is_win == true):
		new_banner_text = "WINNER!"
	else:
		new_banner_text = "LOSER!"
	instruction_label.text = new_banner_text
	animation_player.play(ANIM_END)
