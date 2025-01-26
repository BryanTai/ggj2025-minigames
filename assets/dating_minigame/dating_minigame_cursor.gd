extends CharacterBody2D

signal option_pressed

const SPEED = 1500.0
@onready var selectable_options: Node2D = $"../Selectable_Options"

var hovered_spot: Area2D
var _mouse_target_pos = null

func _ready() -> void:
	for option: Area2D in selectable_options.get_children():
		option.body_entered.connect(_on_option_entered.bind(option))
		option.body_exited.connect(_on_option_exited)

func _input(event):
	if event is InputEventMouseMotion:
		_mouse_target_pos = event.position


func _cursor_update(delta: float) -> void:
	
	# Pick option when pressed
	if Input.is_action_just_pressed("fire"):
		_choose_option()
	
	var direction := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	# Move cursor around
	# Favor keyboard over mouse
	if direction:
		_mouse_target_pos = null
		velocity = direction * SPEED
	elif _mouse_target_pos != null:
		global_position = global_position.move_toward(_mouse_target_pos, SPEED * delta)
		pass
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/2)
		velocity.y = move_toward(velocity.y, 0, SPEED/2)
		
	
	# Velocity move
	if _mouse_target_pos == null:
		move_and_slide()

func _choose_option() -> void: 
	if hovered_spot:
		print("Pressing on " + hovered_spot.name)
		option_pressed.emit(hovered_spot)
		

func _on_option_entered(_body: Node2D, _option: Area2D) -> void:
	hovered_spot = _option
	#print("Hovering over " + hovered_spot.name)

func _on_option_exited(_body: Node2D) -> void:
	hovered_spot = null
	#print("no longer hovering over spot")
