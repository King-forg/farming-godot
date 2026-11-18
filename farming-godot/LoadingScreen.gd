extends CanvasLayer

@onready var progress_bar: ProgressBar = $Root/BottomContainer/VBoxContainer/ProgressBar

func set_progress(value: float) -> void:
	progress_bar.value = value * 100.0
