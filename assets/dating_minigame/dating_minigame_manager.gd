extends BaseMiniGame


@onready var selectable_options: Node2D 		= $Selectable_Options
@onready var hand_cursor: CharacterBody2D 		= $Hand_Cursor
@onready var sprite: Sprite2D 					= $Character/Sprite

@onready var bubs_chan_win 			= preload("res://assets/dating_minigame/yay.png")
@onready var bubs_chan_lose 		= preload("res://assets/dating_minigame/notveryuwu.png")

var rng = RandomNumberGenerator.new()
var rotation_direction = [1, -1].pick_random()
var option_rotation_speed = rng.randf_range(30.0, 60.0)


func _ready() -> void:
	disable_minigame_during_intro_and_outro = false
	super()
	instruction_text = "DATE!" 
	hand_cursor.option_pressed.connect(_on_option_press)

func _process(delta: float) -> void:
	super(delta)


#func _on_timeout() -> void:
#	trigger_game_lose()



### STATE SPECIFIC FUNCTIONS
# Add your game logic to these functions! See README at the top of this file for more info
# You probably won't need all of them so feel free to delete unused ones



## PREPARE STATE

# Called at the beginning of the game
func _on_start_preparing_state() -> void:
	super()
	selectable_options.visible = false
	
	

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
	super()
	
	
	hand_cursor.get_node("Heart_Emitter").emitting = false
	
	# Spawn/enable dialogue options
	var _option_angle_offset 			= int(360 / selectable_options.get_child_count())
	var _option_angle_random_offset 	= rng.randf() * 360
	var _option_angle_random_variance 	= 75
	selectable_options.visible = true
	for _index in selectable_options.get_child_count():
		var _child = selectable_options.get_child(_index)
		
		# position from centre of screen outwards
		var _angle = (_option_angle_offset * _index) + _option_angle_random_offset + (rng.randf() * _option_angle_random_variance)
		_rotate_option(_child, _angle)
		
	

# Called every frame while minigame is in the PLAYING state
func _process_playing_state(delta: float) -> void:
	
	
	# Rotate options in a circle
	var _rotation_speed = option_rotation_speed * delta * rotation_direction
	for _child in selectable_options.get_children():
		_rotate_option(_child, _rotation_speed)
		
	
	# Update cursor
	hand_cursor._cursor_update(delta)

# Called once when the PLAYING state ends (e.g. Win or Lose)
#func _on_end_playing_state() -> void:
#	pass




func _rotate_option(_node, _angle) -> void:
	# rotates child
	_node.rotation += deg_to_rad(_angle)
	
	# Keeps children unrotated
	for _index in _node.get_child_count():
		var _child = _node.get_child(_index)
		_child.global_rotation = 0
		
	

func _on_option_press (_option) -> void:
	# Check if the option we pressed on is the correct one
	
	# First option is the correct one, all others are incorrect
	if _option == selectable_options.get_child(0):
		_option_choose_right()
	else: 
		_option_choose_wrong()
	

func _option_choose_right() -> void:
	trigger_game_win()
	

func _option_choose_wrong() -> void:
	trigger_game_lose()
	



## WIN STATE

# Called once when entering the WIN state
func _on_start_win_state() -> void:
	super()
	sprite.texture = bubs_chan_win
	selectable_options.visible = false
	hand_cursor.get_node("Heart_Emitter").emitting = true

# Called every frame while minigame is in the WIN state
#func _process_win_state(delta: float) -> void:
#	pass



## LOSE STATE

# Called once when entering the LOSE state
func _on_start_lose_state() -> void:
	super()
	sprite.texture = bubs_chan_lose
	selectable_options.visible = false
	pass

# Called every frame while minigame is in the LOSE state
#func _process_lose_state(delta: float) -> void:
#	pass
