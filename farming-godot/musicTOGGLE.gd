extends Button

const MUSIC_VOLUME_DB := -20.0
const MUTED_VOLUME_DB := -80.0
const FADE_DURATION := 0.5

@onready var music: AudioStreamPlayer = get_tree().current_scene.get_node("MusicPlayer")
@onready var music_on: NinePatchRect = $"../Musicon"
@onready var music_off: NinePatchRect = $"../MusicOFF"
@onready var click_sound: AudioStreamPlayer = $"../../ClickSound"

var music_muted := false
var fade_tween: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	click_sound.process_mode = Node.PROCESS_MODE_ALWAYS
	music_on.show()
	music_off.hide()
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	click_sound.play()
	music_muted = !music_muted
	get_tree().current_scene.set("music_muted", music_muted)

	music_on.visible = !music_muted
	music_off.visible = music_muted

	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()

	fade_tween = create_tween()
	fade_tween.tween_property(
		music,
		"volume_db",
		MUTED_VOLUME_DB if music_muted else MUSIC_VOLUME_DB,
		FADE_DURATION
	)
