extends Sprite2D


#Ball hits endzone

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $Area2D/CollisionShape2D/AudioStreamPlayer2D


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print("jonmadden")
	audio_stream_player_2d.play()
	
	pass # Replace with function body.
