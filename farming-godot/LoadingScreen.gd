extends CanvasLayer

@onready var progress_bar: ProgressBar = $Root/BottomContainer/VBoxContainer/ProgressBar
		
func set_progress(value: float) -> void:
	while progress_bar.value < 90:
		progress_bar.value += 1
	progress_bar.value = value * 100.0
