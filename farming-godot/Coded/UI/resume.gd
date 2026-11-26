extends Button

@onready var menu = get_tree().current_scene.get_node("CanvasLayer/CenterContainer/MarginContainer")

@onready var clicksound: AudioStreamPlayer = $"../../ClickSound"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	clicksound.play()
	menu.close_menu()
