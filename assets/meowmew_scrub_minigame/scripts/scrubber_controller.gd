extends CharacterBody2D

signal dirt_spot_cleared

const SPEED = 300.0
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var dirt_spots: Node2D = $"../Bubz/DirtSpots"

var is_scrubbing := false
var hovered_spot: Area2D
var target_pos: Vector2

func _ready() -> void:
	for spot: Area2D in dirt_spots.get_children():
		spot.body_entered.connect(_on_dirt_spot_entered.bind(spot))
		spot.body_exited.connect(_on_dirt_spot_exited)

func _input(event):
	if event is InputEventMouseMotion:
		target_pos = event.position

func _physics_process(delta: float) -> void:
	if is_scrubbing:
		return

	if Input.is_action_just_pressed("fire") and not is_scrubbing:
		_do_scrubbing_action()

	var direction := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	if target_pos and not is_scrubbing:
		global_position = global_position.move_toward(target_pos/2, SPEED * delta)
	else:
		if direction and not is_scrubbing:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/2)
			velocity.y = move_toward(velocity.y, 0, SPEED/2)

		move_and_slide()

func _do_scrubbing_action() -> void: 
	if hovered_spot:
		animation_player.play("scrubscrubscrub")
		var tween = get_tree().create_tween()
		tween.tween_property(hovered_spot, "modulate", Color.TRANSPARENT, 1)
		tween.tween_callback(dirt_spot_cleared.emit)
		tween.tween_callback(hovered_spot.queue_free)
		
	else:
		animation_player.play("already_clean")
	is_scrubbing = true

func _on_dirt_spot_entered(_body: Node2D, dirt_spot: Area2D) -> void:
	hovered_spot = dirt_spot

func _on_dirt_spot_exited(_body: Node2D) -> void:
	hovered_spot = null

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	is_scrubbing = false
