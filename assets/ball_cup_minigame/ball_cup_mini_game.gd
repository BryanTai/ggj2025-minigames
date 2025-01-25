extends BaseMiniGame

@onready var cups_parent: Node = $Cups
@onready var ball: Sprite2D = $Ball
@onready var hand: Sprite2D = $Hand

const HAND_Y_POS = 725
const MOUSE_X_BUFFER = 50

var cup_positions: Array[Vector2]
var cups: Array[Cup]
var hand_positions: Array[Vector2]

var ball_index: int
var hand_index: int
var ball_win_index: int


var can_guess: bool = false

#Start guess timer countdown
# Swap the ball X times
#Ball is in the win index
# player can move hand during PLAYING
# in Can_Guess mode is when FIRE will check

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instruction_text = "Find the Ball!"
	super()
	init_positions()
	
func _on_swapping_complete():
	can_guess = true
	

func init_positions():
	var all_cup_nodes = cups_parent.get_children()
	for cup_node in all_cup_nodes:
		var cup_node_2d: Node2D = cup_node as Node2D
		cups.append(cup_node as Cup)
		cup_positions.append(cup_node_2d.position)
		hand_positions.append(Vector2(cup_node_2d.position.x, HAND_Y_POS))

func set_ball_position(index:int):
	ball.position = cup_positions[index]
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
