extends BaseMiniGame

## This is a template for a MiniGame where the player collects some number of items in 2D space

@export var player_speed: int = 100 #TODO: Adjust this speed as you see fit

@onready var player: Area2D = $Player
@onready var collectables_parent_node: Node = $CollectablesParentNode
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var all_collectables: Array[Node]
var items_collected: int = 0
var total_to_win: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super() ## Do not remove this super() call!
	instruction_text = "Collect!"
	all_collectables = collectables_parent_node.get_children()
	total_to_win = all_collectables.size()
	player.area_entered.connect(on_collect) # Connect to Player's collision signal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta) ## This line will process the State machine! DO NOT REMOVE
	move_player(delta)
	if(items_collected >= total_to_win):
		print("You win!")
		trigger_game_win()

func on_collect(collided: Area2D) -> void:
	if(collided is Collectable):
		items_collected += 1
		audio_stream_player.play()
	
func move_player(delta: float) -> void:
	# This handles Horizontal movement
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	if(horizontal_direction != 0):
		var old_pos = player.position
		var new_x = old_pos.x + (horizontal_direction * player_speed * delta);
		player.set_position(Vector2(new_x, old_pos.y))
	
	# This handles Vertical movement
	var vertical_direction := Input.get_axis("move_up", "move_down")
	if(vertical_direction != 0):
		var old_pos = player.position
		var new_y = old_pos.y + (vertical_direction * player_speed * delta);
		player.set_position(Vector2(old_pos.x, new_y))
