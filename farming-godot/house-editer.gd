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
@onready var tiny_house: Node2D = world2.get_node(
	"Sprites (Y-Sorted)/Player House/Tiny House"
)

const OPTION_GROUPS: Dictionary[String, String] = {
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Left/OptionButton":
		"Walls",
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Left/OptionButton2":
		"Frame",
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Left/OptionButton3":
		"Chimney",
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Left/OptionButton4":
		"WindowL",
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Right/OptionButton":
		"Door",
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Right/OptionButton2":
		"Roof",
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Right/OptionButton3":
		"Roof2",
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Right/OptionButton4":
		"WindowR",
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Right/OptionButton5":
		"Stairs",
}
const OPTION_RANGES: Dictionary[String, Array] = {
	"Door": [0, 10],
	"Stairs": [10, 12],
}
const SAVE_PATH := "user://house_config.json"
const LEGACY_SAVE_PATH := "res://saved.bin"

var house_config: Dictionary = {}

func _ready() -> void:
	load_house_config()
	initialize_tiny_house_variants()
	setup_option_buttons()
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

func initialize_tiny_house_variants() -> void:
	for child: Node in tiny_house.get_children():
		if child is Node2D:
			var saved_index := int(house_config.get(child.name, 0))
			if child.name == "Door":
				show_variant_range(child, saved_index, 0, 10)
				show_variant_range(child, int(house_config.get("Stairs", 0)), 10, 12)
			elif child.name == "Chimney":
				show_variant(child, saved_index)
			elif child.name not in OPTION_RANGES:
				show_variant(child, saved_index)

func setup_option_buttons() -> void:
	for option_path: String in OPTION_GROUPS:
		var option_button := get_node_or_null(option_path) as OptionButton
		var group_name: String = OPTION_GROUPS[option_path]
		var group_node_name := "Door" if group_name == "Stairs" else group_name
		var group := tiny_house.get_node_or_null(group_node_name) as Node2D
		if option_button == null or group == null:
			continue

		var range_start := 0
		var range_end := group.get_child_count()
		if group_name in OPTION_RANGES:
			range_start = int(OPTION_RANGES[group_name][0])
			range_end = int(OPTION_RANGES[group_name][1])
		var variant_count := range_end - range_start

		if option_button.item_count != variant_count:
			option_button.clear()
			for variant_index in variant_count:
				option_button.add_item(
					str(variant_index + 1),
					variant_index
				)

		var saved_index := int(house_config.get(group_name, 0))
		saved_index = clampi(saved_index, 0, variant_count - 1)
		option_button.select(saved_index)
		show_variant_range(group, saved_index, range_start, range_end)
		option_button.item_selected.connect(
			_on_house_option_selected.bind(option_button, group_name)
		)

func _on_house_option_selected(
	index: int,
	option_button: OptionButton,
	group_name: String
) -> void:
	if option_button == null:
		return

	var group_node_name := "Door" if group_name == "Stairs" else group_name
	var group := tiny_house.get_node_or_null(group_node_name) as Node2D
	if group != null:
		var range_start := 0
		var range_end := group.get_child_count()
		if group_name in OPTION_RANGES:
			range_start = int(OPTION_RANGES[group_name][0])
			range_end = int(OPTION_RANGES[group_name][1])
		index = clampi(index, 0, range_end - range_start - 1)
		show_variant_range(group, index, range_start, range_end)
		house_config[group_name] = index
		save_house_config()

func show_variant(group: Node2D, index: int) -> void:
	show_variant_range(group, index, 0, group.get_child_count())

func show_variant_range(group: Node2D, index: int, range_start: int, range_end: int) -> void:
	index = clampi(index, 0, range_end - range_start - 1)
	for variant_index in range(range_start, range_end):
		var variant := group.get_child(variant_index)
		if variant is CanvasItem:
			variant.visible = variant_index - range_start == index

func load_house_config() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file != null:
			var parsed = JSON.parse_string(file.get_as_text())
			file.close()
			if parsed is Dictionary:
				house_config = parsed
				return

	if FileAccess.file_exists(LEGACY_SAVE_PATH):
		var legacy_file := FileAccess.open(LEGACY_SAVE_PATH, FileAccess.READ)
		if legacy_file != null:
			var parsed = JSON.parse_string(legacy_file.get_as_text())
			legacy_file.close()
			if parsed is Dictionary:
				var legacy_wall := int(parsed.get("wall", 1)) - 1
				house_config["Walls"] = clampi(legacy_wall, 0, 23)

func save_house_config() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not save house configuration to %s" % SAVE_PATH)
		return

	file.store_string(JSON.stringify(house_config))
	file.close()
