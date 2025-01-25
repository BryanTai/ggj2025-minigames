## GOZI'S NOTES
# pick a random number between like 1 and 7.
# pick that number of random numbers between 1 and 30.
# make those numbered bubble sprites be whole, clickable, and poppable.
# all others will be popped already.
# when all whole bubbles are popped, that is a win.
# if there are any whole bubbles remaining when the time limit runs out, that is a loss.

# i tried really hard to do the randomness thing but i gotta get something out the door. U_U

extends BaseMiniGame

func _ready() -> void:
	instruction_text = "RELAX!" 

func _process(delta: float) -> void:
	super(delta) ## This line will process the State machine! DO NOT REMOVE

# this sets the poppable bubbles to be whole.
func _process_preparing_state(delta: float) -> void:
	$"Bubbles/2/AnimatedSprite2D".animation = "whole1"
	$"Bubbles/8/AnimatedSprite2D".animation = "whole1"
	$"Bubbles/10/AnimatedSprite2D".animation = "whole1"
	$"Bubbles/16/AnimatedSprite2D".animation = "whole1"
	$"Bubbles/22/AnimatedSprite2D".animation = "whole1"

# manually check every frame if all of the bubbles are popped LOLOLOL
func _process_playing_state(delta: float) -> void:
	if $"Bubbles/2/AnimatedSprite2D".animation == "popped2" and $"Bubbles/8/AnimatedSprite2D".animation == "popped2" and $"Bubbles/10/AnimatedSprite2D".animation == "popped2" and $"Bubbles/16/AnimatedSprite2D".animation == "popped2" and $"Bubbles/22/AnimatedSprite2D".animation == "popped2":
		trigger_game_win()
		
	
	
