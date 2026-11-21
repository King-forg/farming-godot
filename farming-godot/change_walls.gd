extends OptionButton

const SAVE_PATH: String = "user://house_config.json"
const LEGACY_SAVE_PATH: String = "res://saved.bin"

func _on_item_selected(index:int) -> void:
	var data := load_data()
	data["Walls"] = index
	data["wall"] = index + 1

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not open %s" % SAVE_PATH)
		return
	file.store_string(JSON.stringify(data))
	file.close()

func load_data() -> Dictionary:
	if FileAccess.file_exists(SAVE_PATH):
		var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file != null:
			var parsed = JSON.parse_string(file.get_as_text())
			file.close()
			if parsed is Dictionary:
				return parsed
	return {}
