extends Area2D

@onready var cursor: Area2D = $"../Cursor"
@onready var body: CollisionShape2D = $CollisionShape2D

var is_hovering = false

@onready var animated_sprite_2d = $AnimatedSprite2D

func _on_area_entered(body):
	is_hovering = true

func _on_area_exited(body):
	is_hovering = false


func _process(_delta:float):
#Animate the Button
	if is_hovering == true:
		animated_sprite_2d.animation=("hover")
	elif (is_hovering==true and Input.is_action_just_pressed("fire")):
		animated_sprite_2d.animation=("click")
		print ("click! bubbleware")
	else:
		animated_sprite_2d.animation=("default")
