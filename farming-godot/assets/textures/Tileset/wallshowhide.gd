extends Node2D

const SAVE_PATH := "user://house_config.json"
const LEGACY_SAVE_PATH := "res://saved.bin"

var last_saved_text: String = ""
const HOUSE_GROUPS := [
	"Walls",
	"Roof",
	"Frame",
	"Roof2",
	"WindowL",
	"WindowR",
]
const HOUSE_RANGES := {
	"Door": [0, 10],
	"Stairs": [10, 12],
}

func _ready() -> void:
	load_and_apply()

func _process(_delta: float) -> void:
	var file_text := read_saved_text()
	if file_text != last_saved_text:
		load_and_apply(file_text)

func load_and_apply(saved_text: String = "") -> void:
	var file: FileAccess = null
	if saved_text == "":
		if FileAccess.file_exists(SAVE_PATH):
			file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		elif FileAccess.file_exists(LEGACY_SAVE_PATH):
			file = FileAccess.open(LEGACY_SAVE_PATH, FileAccess.READ)
	elif saved_text != "":
		last_saved_text = saved_text

	if saved_text == "" and file != null:
		saved_text = file.get_as_text()
		file.close()
	last_saved_text = saved_text

	var data = JSON.parse_string(saved_text)
	if data is Dictionary:
		for group_name: String in HOUSE_GROUPS:
			var saved_index := int(data.get(group_name, 0))
			var group := get_node_or_null(group_name) as Node2D
			if group != null:
				show_variant(group, saved_index)

		var chimney := get_node_or_null("Chimney") as Node2D
		if chimney != null:
			show_chimney_sides(
				chimney,
				int(data.get("ChimneyL", 0)),
				int(data.get("ChimneyR", 0))
			)

		var door := get_node_or_null("Door") as Node2D
		if door != null:
			show_variant_range(
				door,
				int(data.get("Door", 0)),
				0,
				10
			)
			show_variant_range(
				door,
				int(data.get("Stairs", 0)),
				10,
				12
			)

		if not data.has("Walls"):
			var legacy_wall := int(data.get("wall", 1)) - 1
			var walls := get_node_or_null("Walls") as Node2D
			if walls != null:
				show_variant(walls, legacy_wall)

func show_variant(group: Node2D, index: int) -> void:
	var variant_count := group.get_child_count()
	index = clampi(index, 0, variant_count - 1)
	for variant_index in variant_count:
		var variant := group.get_child(variant_index)
		if variant is CanvasItem:
			variant.visible = variant_index == index

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

func read_saved_text() -> String:
	var file: FileAccess = null
	if FileAccess.file_exists(SAVE_PATH):
		file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	elif FileAccess.file_exists(LEGACY_SAVE_PATH):
		file = FileAccess.open(LEGACY_SAVE_PATH, FileAccess.READ)

	if file == null:
		return ""

	var text := file.get_as_text()
	file.close()
	return text
