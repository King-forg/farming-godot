extends Button

const LOADING_SCREEN = preload("res://LoadingScreen.tscn")

var loading := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if loading:
		return

	var scene = get_tree().current_scene.scene_file_path
	if scene == "res://assets/textures/Tileset/debugmap.tscn":
		_load_scene("res://assets/textures/Tileset/MainMap.tscn")
	else:
		_load_scene("res://assets/textures/Tileset/debugmap.tscn")

func _load_scene(target_scene: String) -> void:
	loading = true

	get_tree().paused = false

	var loading_screen := LOADING_SCREEN.instantiate()
	get_tree().current_scene.add_child(loading_screen)

	await get_tree().process_frame
	await get_tree().process_frame

	get_tree().call_deferred("set", "paused", false)
	var error := get_tree().change_scene_to_file(target_scene)
	if error != OK:
		push_error("Failed to load scene: " + target_scene)
		if is_instance_valid(loading_screen):
			loading_screen.queue_free()
		loading = false
