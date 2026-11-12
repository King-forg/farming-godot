extends Node2D

@onready var music = $MusicPlayer

var musicvol = 0.1
var fade = 3.0

var musictracks = [preload("res://assets/music/music1.mp3"), preload("res://assets/music/music2.mp3")]

func _ready():
	music.volume_db = -80
	start_music()
	
func start_music():
	await get_tree().create_timer(randf_range(5.0, 20.0)).timeout
	
	while true:
		music.stream = musictracks.pick_random()
		music.play()
		
		var fade_in = create_tween()
		fade_in.tween_property(music, "volume_db", linear_to_db(musicvol), fade)
		
		await music.finished
		
		var fade_out = create_tween()
		fade_out.tween_property(music, "volume_db", -80, fade)
		
		await fade_out.finished
