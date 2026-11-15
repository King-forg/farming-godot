extends MarginContainer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu") and not event.is_echo():
		if visible:
			close_menu()
		else:
			open_menu()

		get_viewport().set_input_as_handled()

func open_menu() -> void:
	show()
	get_tree().paused = true

func close_menu() -> void:
	hide()
	get_tree().paused = false
