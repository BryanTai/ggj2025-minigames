extends CharacterBody2D

signal stabbed_in_the_center

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

const SPEED = 300.0

var is_stabbing := false
var is_perfectly_aligned := false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("fire") and not is_stabbing:
		_do_stabby_stab()
		is_stabbing = true
		
		if is_perfectly_aligned:
			print("Stab right in the middle!")
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
	var current_pos := position
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", current_pos, 0.4)
	tween.tween_property(self, "position", current_pos + Vector2(3, 0), 0.05)
	tween.tween_property(self, "position", current_pos + Vector2(-6, 0), 0.05)
	tween.tween_property(self, "position", current_pos + Vector2(6, 0), 0.05)
	tween.tween_property(self, "position", current_pos + Vector2(-6, 0), 0.05)
	tween.tween_property(self, "position", current_pos + Vector2(6, 0), 0.05)
	tween.tween_property(self, "position", current_pos, 0.05)


func _on_straw_detected(_body: Node2D, is_centered: bool) -> void:
	if is_centered:
		print("Centered!")
	is_perfectly_aligned = is_centered
