extends NinePatchRect

@onready var button: Button = $"../Button"

func _on_button_toggled(toggled_on: bool) -> void:
	visible = !toggled_on
