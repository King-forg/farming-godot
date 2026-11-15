extends Button

@onready var clicksound: AudioStreamPlayer = $"../../ClickSound"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	clicksound.play()
	await get_tree().create_timer(1).timeout
	get_tree().quit()
