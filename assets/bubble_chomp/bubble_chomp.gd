extends BaseMiniGame

var bubblesPopped = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instruction_text = "CHAWMP DEM BUBBS!" # This text will display during the PREPARING phase
	super() ## Do not remove this super() call!
	## Put any logic you'd like to happen at the beginning of your minigame here!

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta) ## This line will process the State machine! DO NOT REMOVE
	## Use this _process function for your game logic!
	if bubblesPopped == 5:
		trigger_game_win()
