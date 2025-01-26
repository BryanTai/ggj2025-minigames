


#Bubble pops when it is collided with 
extends AnimatedSprite2D
@onready var bubble_pop_sfx: AudioStreamPlayer = $bubblePop_sfx
@onready var chomp_sfx: AudioStreamPlayer = $chomp_sfx



#Random Bubble Movement
var speed = 100
var value = randf_range(-1, 1)
var direction = Vector2(value,value).normalized()

func _physics_process(delta):
	position += direction * speed * delta



func bubble_body_entered(body: Node2D) -> void:

	print (body.name)
	if body.name == "PlayerHoshi":
		play ("pop")
		bubble_pop_sfx.play()
		chomp_sfx.play()
		$"..".bubblesPopped += 1
		
	if body.name == "WorldBoundaryX":
		direction = Vector2(direction.x*-1,direction.y)
		
	if body.name == "WorldBoundaryY":
		direction = Vector2(direction.x,direction.y*-1)

func _on_animation_finished() -> void:
	queue_free()
