extends Control

@onready var world2: Node2D = get_node(
	"Centre/Center2/Center3/Left/ColorRect/SubViewportContainer/SubViewport/World2"
)
@onready var housecam: Camera2D = world2.get_node(
	"Sprites (Y-Sorted)/Player House/Tiny House/HouseCamera"
)
@onready var playercam: Camera2D = world2.get_node(
	"Sprites (Y-Sorted)/Entities/Player/Camera2D"
)

func _ready() -> void:
	show_house_gui()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		hide_house_gui()

func show_house_gui() -> void:
	show()
	if housecam:
		if playercam:
			playercam.enabled = false
		housecam.enabled = true
		housecam.make_current()


func hide_house_gui() -> void:
	hide()
	get_tree().change_scene_to_file(
		"res://assets/textures/Tileset/MainMap.tscn"
	)
