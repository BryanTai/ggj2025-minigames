extends BaseMiniGame

## This is a template for a MiniGame where the player must press the button during a window of time
@onready var waiting_timer: Timer = $WaitingTimer
@onready var window_timer: Timer = $WindowTimer
@onready var label: Label = $Label
@onready var animated_sprite_2d: AnimatedSprite2D = $Background/AnimatedSprite2D
@onready var player_2d: Area2D = $Player2D



const MIN_WAIT_SEC: float = 2.0
const MAX_WAIT_SEC: float = 4.0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super() ## Do not remove this super() call!
	instruction_text = "REACT!" 
	var wait_seconds = rng.randf_range(MIN_WAIT_SEC, MAX_WAIT_SEC) # Pick a random time to wait
	waiting_timer.wait_time = wait_seconds
	waiting_timer.timeout.connect(start_window_timer) # Connect to first timer's timeout signal
	window_timer.timeout.connect(on_window_timeout) # Connect to the window timer's timeout signal
	label.text = "Wait for it..."

# Called once when entering the PLAYING state (e.g. once the player gains control)
func _on_start_playing_state() -> void:
	waiting_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta) ## This line will process the State machine! DO NOT REMOVE
	## Use this _process function for your game logic!

	# Pressing the button outside of the timing window will lose the game
	if(Input.is_action_just_pressed("fire")):
		if(window_timer.is_stopped()):
			animated_sprite_2d.play("Loss")
			player_2d.queue_free()
			label.text = "Missed!"
			trigger_game_lose()
		else:
			player_2d.queue_free()
			animated_sprite_2d.play("Win")
			label.text = "You win!"
			trigger_game_win()

func start_window_timer() -> void:
	label.text = "NOW!"
	animated_sprite_2d.play("Shake")
	window_timer.start()
	
func on_window_timeout() -> void:
	label.text = "Too late..."
