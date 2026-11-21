extends Control

@onready var world2: Node2D = get_node_or_null(
	"Centre/Center2/Center3/Left/Panel/SubViewportContainer/SubViewport/World2"
) as Node2D
@onready var housecam: Camera2D = (
	world2.get_node_or_null("Sprites (Y-Sorted)/Player House/Tiny House/HouseCamera") as Camera2D
	if world2 != null
	else null
)
@onready var playercam: Camera2D = (
	world2.get_node_or_null("Sprites (Y-Sorted)/Entities/Player/Camera2D") as Camera2D
	if world2 != null
	else null
)
@onready var tiny_house: Node2D = (
	world2.get_node_or_null("Sprites (Y-Sorted)/Player House/Tiny House") as Node2D
	if world2 != null
	else null
)

const OPTION_GROUPS: Dictionary[String, String] = {
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Left/OptionButton":
		"Walls",
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Left/OptionButton2":
		"Frame",
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Left/OptionButton3":
		"ChimneyL",
	"Centre/Center2/Center3/Right/MarginContainer/HBoxContainer/Left/OptionButton6":
		"ChimneyR",
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
var menu_events: Array[InputEvent] = []

func _ready() -> void:
	disable_menu_input()
	load_house_config()
	initialize_tiny_house_variants()
	setup_option_buttons()
	show_house_gui()

func disable_menu_input() -> void:
	menu_events = InputMap.action_get_events("menu")
	InputMap.action_erase_events("menu")

func restore_menu_input() -> void:
	InputMap.action_erase_events("menu")
	for menu_event: InputEvent in menu_events:
		InputMap.action_add_event("menu", menu_event)

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
	restore_menu_input()
	get_tree().change_scene_to_file(
		"res://assets/textures/Tileset/MainMap.tscn"
	)

func _exit_tree() -> void:
	restore_menu_input()

func initialize_tiny_house_variants() -> void:
	if tiny_house == null:
		return

	for child: Node in tiny_house.get_children():
		if child is Node2D:
			var saved_index := int(house_config.get(child.name, 0))
			if child.name == "Door":
				show_variant_range(child, saved_index, 0, 10)
				show_variant_range(child, int(house_config.get("Stairs", 0)), 10, 12)
			elif child.name == "Chimney":
				show_chimney_sides(
					child,
					int(house_config.get("ChimneyL", 0)),
					int(house_config.get("ChimneyR", 0))
				)
			elif child.name not in OPTION_RANGES:
				show_variant(child, saved_index)

func setup_option_buttons() -> void:
	if tiny_house == null:
		return

	for option_path: String in OPTION_GROUPS:
		var option_button := get_node_or_null(option_path) as OptionButton
		var group_name: String = OPTION_GROUPS[option_path]
		var group_node_name := "Door" if group_name == "Stairs" else group_name
		if group_name == "ChimneyL" or group_name == "ChimneyR":
			group_node_name = "Chimney"
		var group := tiny_house.get_node_or_null(group_node_name) as Node2D
		if option_button == null or group == null:
			continue

		var range_start := 0
		var range_end := group.get_child_count()
		if group_name == "ChimneyL" or group_name == "ChimneyR":
			range_start = 0
			range_end = 3
		if group_name in OPTION_RANGES:
			range_start = int(OPTION_RANGES[group_name][0])
			range_end = int(OPTION_RANGES[group_name][1])
		var variant_count := range_end - range_start

		if option_button.item_count != variant_count:
			option_button.clear()
			if group_name == "ChimneyL" or group_name == "ChimneyR":
				option_button.add_item("Off", 0)
				option_button.add_item("Chimney 1", 1)
				option_button.add_item("Chimney 2", 2)
			else:
				for variant_index in variant_count:
					option_button.add_item(
						str(variant_index + 1),
						variant_index
					)

		var saved_index := int(house_config.get(group_name, 0))
		saved_index = clampi(saved_index, 0, variant_count - 1)
		option_button.select(saved_index)
		if group_name == "ChimneyL" or group_name == "ChimneyR":
			var left_index := int(house_config.get("ChimneyL", 0))
			var right_index := int(house_config.get("ChimneyR", 0))
			if group_name == "ChimneyL":
				left_index = saved_index
			else:
				right_index = saved_index
			show_chimney_sides(group, left_index, right_index)
		else:
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
	if group_name == "ChimneyL" or group_name == "ChimneyR":
		group_node_name = "Chimney"
	var group := tiny_house.get_node_or_null(group_node_name) as Node2D
	if group != null:
		var range_start := 0
		var range_end := group.get_child_count()
		if group_name == "ChimneyL" or group_name == "ChimneyR":
			range_start = 0
			range_end = 3
		if group_name in OPTION_RANGES:
			range_start = int(OPTION_RANGES[group_name][0])
			range_end = int(OPTION_RANGES[group_name][1])
		index = clampi(index, 0, range_end - range_start - 1)
		if group_name == "ChimneyL" or group_name == "ChimneyR":
			var left_index := int(house_config.get("ChimneyL", 0))
			var right_index := int(house_config.get("ChimneyR", 0))
			if group_name == "ChimneyL":
				left_index = index
			else:
				right_index = index
			show_chimney_sides(group, left_index, right_index)
		else:
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

func show_chimney_sides(group: Node2D, left_index: int, right_index: int) -> void:
	for variant_index in group.get_child_count():
		var variant := group.get_child(variant_index)
		if variant is CanvasItem:
			variant.visible = false

	left_index = clampi(left_index, 0, 2)
	right_index = clampi(right_index, 0, 2)

	if left_index == 1:
		var chimney_left := group.get_node_or_null("ChimneyL")
		if chimney_left is CanvasItem:
			chimney_left.visible = true
	elif left_index == 2:
		var chimney_left_2 := group.get_node_or_null("ChimneyL2")
		if chimney_left_2 is CanvasItem:
			chimney_left_2.visible = true

	if right_index == 1:
		var chimney_right := group.get_node_or_null("ChimneyR")
		if chimney_right is CanvasItem:
			chimney_right.visible = true
	elif right_index == 2:
		var chimney_right_2 := group.get_node_or_null("ChimneyR2")
		if chimney_right_2 is CanvasItem:
			chimney_right_2.visible = true

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
