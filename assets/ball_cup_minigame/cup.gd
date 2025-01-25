class_name Cup
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func raise_cup():
	animation_player.play("raise_cup")

func lower_cup():
	animation_player.play("lower_cup")
