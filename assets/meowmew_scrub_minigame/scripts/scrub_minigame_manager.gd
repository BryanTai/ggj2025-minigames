extends BaseMiniGame

const SPOT_AMOUNT := 9
const BUBZ_WIN = preload("res://assets/meowmew_scrub_minigame/sprites/bubz_win.png")

@onready var dirt_spots: Node2D = $Bubz/DirtSpots
@onready var scrubber: CharacterBody2D = $Scrubber
@onready var sprite: Sprite2D = $Bubz/Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var score := 0


func _ready() -> void:
	instruction_text = "Clean Bubs! He's filthy!" 
	super()
	scrubber.dirt_spot_cleared.connect(_increment_score)

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
	
	var ds: Array = dirt_spots.get_children()
	for _n in 3:
		var i = randi_range(0, ds.size()-1)
		var spot: Area2D = ds[i]
		
		spot.visible = true
		spot.monitoring = true
		
		ds.pop_at(i)

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
#func _on_end_playing_state() -> void:
#	pass

## WIN STATE

# Called once when entering the WIN state
func _on_start_win_state() -> void:
	super()
	sprite.texture = BUBZ_WIN

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

func _increment_score() -> void:
	score += 1
	if score == 3:
		trigger_game_win()
