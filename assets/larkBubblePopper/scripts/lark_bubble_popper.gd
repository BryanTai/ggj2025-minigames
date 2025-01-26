extends BaseMiniGame

var larkBubble = load("res://assets/larkBubblePopper/scenes/lark_bubble.tscn")
var bubblesPopped = 0
var currentFrame = 0
var catBubbleCount = 0
var hasWon = false

@onready var cursor: Area2D = $Player2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super() ## Do not remove this super() call!
	instruction_text = "Click the -CAT- bubbles" # This text will display during the PREPARING phase
	## Put any logic you'd like to happen at the beginning of your minigame here!

func _process(delta:float) -> void:
	super(delta)
	# When fire button pressed, check all overlapping bubbles for cats
	if(Input.is_action_just_pressed("fire")):
		var all_overlapping = cursor.get_overlapping_areas()
		for overlapping in all_overlapping:
			if overlapping is LarkBubble:
				var lark_bubble = overlapping as LarkBubble
				if lark_bubble.iscat == true:
					catBubbleCount -= 1
					$popnoise.play()
					lark_bubble.queue_free()

func _on_bubble_spawn_countdown_timeout() -> void:
	# Bouncy: Tell me. For whom do you fight? Hmph! How very glib. And do you believe in Eorzea? Eorzea's unity is forged of falsehoods. Its city-states are built on deceit. And its faith is an instrument of deception. It is naught but a cobweb of lies. To believe in Eorzea is to believe in nothing. In Eorzea, the beast tribes often summon gods to fight in their stead--though your comrades only rarely respond in kind. Which is strange, is it not? Are the "Twelve" otherwise engaged? I was given to understand
	# Gogozi: they were your protectors. If you truly believe them your guardians, why do you not repeat the trick that served you so well at Carteneau, and call them down? They will answer--so long as you lavish them with crystals and gorge them on aether. Your gods are no different than those of the beasts--eikons every one. Accept but this, and you will see how Eorzea's faith is bleeding the land dry. Nor is this unknown to your masters. Which prompts the question: Why do they cling to these false deities
	for i in 5:
		# demonknighz: creemdom
		create_bubble()

func create_bubble():
	var bubbleinstance = larkBubble.instantiate() as LarkBubble
	add_child(bubbleinstance)
	var randomPos = Vector2(randi_range(200,800),800)
	bubbleinstance.set_position(randomPos)
	# Randomly determine if this bubble is a Cat
	var randomcat = randi_range(1,100)
	if(randomcat > 82 && hasWon == false):
		bubbleinstance.iscat = true
		catBubbleCount += 1
		bubbleinstance.load_cat_sprite()

func _on_timeout() -> void:
	if(catBubbleCount == 0):
		hasWon = true
		trigger_game_win()
	else:
		trigger_game_lose()
