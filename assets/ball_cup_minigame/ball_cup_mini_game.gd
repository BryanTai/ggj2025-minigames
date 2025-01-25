extends BaseMiniGame

@onready var cups_parent: Node = $Cups
@onready var ball: Sprite2D = $Ball
@onready var hand: Sprite2D = $Hand
@onready var swapping_timer: Timer = $SwappingTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const HAND_Y_POS = 725
const BALL_Y_OFFSET = 70
const MOUSE_X_BUFFER = 50

var cup_positions: Array[Vector2]
var cups: Array[Cup]
var hand_positions: Array[Vector2]

var ball_index: int
var hand_index: int
var ball_win_index: int

var swaps_made: int
@export var total_swaps: int = 5

var can_guess: bool = false

#Start guess timer countdown
# Swap the ball X times
#Ball is in the win index
# player can move hand during PLAYING
# in Can_Guess mode is when FIRE will check

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instruction_text = "Find the Ball!"
	init_positions()
	cups[1].visible = false
	super()
	set_ball_position(1)

func _on_start_playing_state():
	cups[1].visible = true
	cups[1].lower_cup()
	
func make_random_swap():
	swaps_made += 1
	var first_index = randi_range(0,2)
	var second_index = randi_range(0,2)
	if(first_index == second_index):
		swap_all_cups()
	else:
		swap_cups(min(first_index, second_index), max(first_index, second_index))

func swap_cups(first:int, second:int):
	var animation_name = "swap_cups_" + str(first) + "_" + str(second)
	animation_player.play(animation_name)
	if(ball_index == first):
		ball_index = second
	elif(ball_index == second):
		ball_index = first

func swap_all_cups():
	animation_player.play("swap_all_cups")
	ball_index += 1
	if(ball_index > 2):
		ball_index = 0
		
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	#animation_player.play("RESET")
	if(swaps_made < total_swaps):
		make_random_swap()
	else:
		_on_all_swaps_complete()
	
func _on_all_swaps_complete():
	set_ball_position(ball_win_index)
	can_guess = true

func init_positions():
	var all_cup_nodes = cups_parent.get_children()
	for cup_node in all_cup_nodes:
		var cup_node_2d: Node2D = cup_node as Node2D
		cups.append(cup_node as Cup)
		cup_positions.append(cup_node_2d.position)
		hand_positions.append(Vector2(cup_node_2d.position.x, HAND_Y_POS))

func set_ball_position(index:int):
	var cup_pos = cup_positions[index]
	ball.position = Vector2(cup_pos.x, cup_pos.y + BALL_Y_OFFSET)
	ball_index = index
	ball_win_index = index
	
func set_hand_position(index:int):
	hand.position = hand_positions[index]
	hand_index = index
	
func move_hand_left():
	if(hand_index > 0):
		hand_index -= 1
		set_hand_position(hand_index)
	
func move_hand_right():
	if(hand_index < 2):
		hand_index += 1
		set_hand_position(hand_index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	
	if(Input.is_action_just_pressed("move_left")):
		move_hand_left()
	elif(Input.is_action_just_pressed("move_right")):
		move_hand_right()
	
	
	if(can_guess and Input.is_action_just_pressed("fire")):
		if(ball_index == hand_index):
			trigger_game_win()
		else:
			trigger_game_lose()

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_x = event.position.x
		if (mouse_x < cup_positions[0].x + MOUSE_X_BUFFER):
			set_hand_position(0) #left column
		elif (mouse_x < cup_positions[2].x - MOUSE_X_BUFFER):
			set_hand_position(1) #middle column
		else:
			set_hand_position(2) #right column
