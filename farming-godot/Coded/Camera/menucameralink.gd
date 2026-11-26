extends Node2D

@export var camera: Camera2D

func _process(_delta):
	global_position = camera.get_screen_center_position()
