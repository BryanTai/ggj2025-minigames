extends CanvasLayer

const BUBBLE_DEFAULT_PITCH: float = 0.6

@onready var time_bar: TextureProgressBar = $TimerLabel/TimeBar
@onready var bubble_pop: AudioStreamPlayer = $TimerLabel/BubblePop
@onready var bubble_timer: Timer = $TimerLabel/TimerBubbles/BubbleTimer
@onready var timer_bubbles: Control = $TimerLabel/TimerBubbles
@onready var lives_left: HBoxContainer = $Lives/LifeNodes/LivesLeft

var max_time: float
var bubble_pitch: float = 0.6
var current_bubble: int = 0
var lives: int = 5

func remove_a_life() -> void:
	if lives > 0:
		lives -= 1
		lives_left.get_child(lives).visible = false
	
func reset_lives() -> void:
	for life: TextureRect in lives_left.get_children():
		life.visible = true
		
func reset_time_bar() -> void:
	time_bar.value = time_bar.max_value
	bubble_pop.pitch_scale = BUBBLE_DEFAULT_PITCH
	current_bubble = 0
	for n in 4:
		timer_bubbles.get_child(n).visible = true

func adjust_time_bar_length(time_left: float) -> void:
	var time_percent = time_left / max_time * 100
	time_bar.value = time_percent

func start_bubble_popper_timer() -> void:
	bubble_timer.start(1)

func stop_bubble_popper_timer() -> void:
	bubble_timer.stop()

func _on_bubble_timer_timeout() -> void:
	if current_bubble < 4:
		timer_bubbles.get_child(current_bubble).visible = false
		bubble_pop.play()
		bubble_pop.pitch_scale += 0.2
		current_bubble += 1
	else:
		stop_bubble_popper_timer()
