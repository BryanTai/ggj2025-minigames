


#Bubble pops when it is collided with 
extends AnimatedSprite2D

#Random Bubble Movement
var speed = 100
var value = randf_range(-1, 1)
var direction = Vector2(value,value).normalized()

func _physics_process(delta):
	position += direction * speed * delta



func bubble_body_entered(body: Node2D) -> void:

	print (body.name)
	if body.name == "PlayerHoshi":
		print ("bubble collided")
		play ("pop")
		$"..".bubblesPopped += 1
		
	if body.name == "WorldBoundaryX":
		direction = Vector2(direction.x*-1,direction.y)
		
	if body.name == "WorldBoundaryY":
		direction = Vector2(direction.x,direction.y*-1)

func _on_animation_finished() -> void:
	queue_free()
