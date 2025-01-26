extends BaseMiniGame

@onready var power_arm: Node2D = $PowerMeter/PowerArm
@onready var cursor: Player2D = $Cursor
@onready var butt_animated_sprite_2d: AnimatedSprite2D = $Butt/Butt_AnimatedSprite2D
@onready var power_arm_animation_player: AnimationPlayer = $PowerMeter/PowerArm/AnimationPlayer

var smacked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instruction_text = "SMACK!" 
	
	## Set this flag to "false" in your MiniGame if you don't want everything disabled outside of the PLAYING state
	disable_minigame_during_intro_and_outro = false
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("fire"):
		if not smacked:
			print (power_arm.rotation_degrees)
			smacked = true
			#butt_animated_sprite_2d.animation = "smack"
		
			power_arm_animation_player.pause()
			
			if power_arm.rotation_degrees > 55:
				butt_animated_sprite_2d.animation = "smack"
				
				trigger_game_win()
			else:
				trigger_game_lose()


func _on_start_playing_state():
	cursor.movement_enabled = true
