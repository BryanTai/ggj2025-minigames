extends Node2D

signal nyatasha_got_hurt
@onready var nyatasha: Node2D = $".."
@onready var badpop: AudioStreamPlayer = $"../badpop"
@onready var goodpop: AudioStreamPlayer = $"../goodpop"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if(direction != 0):
		rotation += direction * 0.05

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_at(get_global_mouse_position())
		rotation += 45.5

func _on_nyatasha_hurtbox_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if(area.get_parent().isbad):
		badpop.play()
		nyatasha_got_hurt.emit()
		nyatasha.visible = false # change this line for death animation?
	else:
		goodpop.play()
		area.get_parent().queue_free()


func _on_nyatasha_hitbox_2d_area_entered(area: Area2D) -> void:
	if(area.get_parent().isbad):
		badpop.play()
	else:
		goodpop.play()
	area.get_parent().queue_free()
