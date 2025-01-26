extends CharacterBody2D

signal stabbed_in_the_center

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var sprite: Sprite2D = $Sprite
@onready var tea_drop_emitter: GPUParticles2D = $"../BubbleCup/TeaDropEmitter"
@onready var straw_shadow: Sprite2D = $StrawShadow

const SPEED = 50.0
const PIERCE_STRAW = preload("res://assets/bubble_tea_minigame/sprites/pierce_straw.png")
const BENT_STRAW = preload("res://assets/bubble_tea_minigame/sprites/bent_straw.png")

@export var start_pos := Vector2(256, 358)

var is_stabbing := false
var is_perfectly_aligned := false

func display_win_animation() -> void:
	sprite.texture = PIERCE_STRAW
	sprite.position.y = -120
	tea_drop_emitter.emitting = true
	straw_shadow.visible = false

func display_lose_animation() -> void:
	animation_player.play("SPILL")

func _ready() -> void:
	position = start_pos

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire") and not is_stabbing:
		_do_stabby_stab()
		is_stabbing = true
		
		if is_perfectly_aligned:
			stabbed_in_the_center.emit()
		
	if is_stabbing:
		return
		
	var direction := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	
func _do_stabby_stab() -> void:
	animation_player.play("STAB")
	_wiggle_straw()

func _on_straw_detected(_body: Node2D, is_centered: bool) -> void:
	is_perfectly_aligned = is_centered
	
func _wiggle_straw() -> void:
	var current_pos := position	
	var tween = get_tree().create_tween()
	
	tween.tween_property(self, "position", current_pos, 0.4)
	tween.tween_property(self, "position", current_pos + Vector2(3, 0), 0.05)
	tween.tween_property(self, "position", current_pos + Vector2(-6, 0), 0.05)
	tween.tween_property(self, "position", current_pos + Vector2(6, 0), 0.05)
	tween.tween_property(self, "position", current_pos + Vector2(-6, 0), 0.05)
	tween.tween_property(self, "position", current_pos + Vector2(6, 0), 0.05)
	tween.tween_property(self, "position", current_pos, 0.05)
