
extends CharacterBody2D

@export var speed: float = 50.0
@export var run_speed: float = 80.0

var footstep_timer: float = 0.0
@export var floor_ray: RayCast2D

@export var default_sound: Array[AudioStream] = []
@export var grass_sound: Array[AudioStream] = []
@export var wood_sound: Array[AudioStream] = []
@export var stone_sound: Array[AudioStream] = []

@export var footstep_players: Array[AudioStreamPlayer2D]

func play_footstep(sound: AudioStream) -> void:
	for player in footstep_players:
		if not is_instance_valid(player):
			continue
		
		if not player.playing:
			player.stream = sound
			player.pitch_scale = randf_range(0.92, 1.08)
			player.play()
			return
	
	var player = footstep_players[0]
	player.stop()
	player.stream = sound
	player.pitch_scale = randf_range(0.92, 1.08)
	player.play()

func footstepsound() -> void:
	if not floor_ray:
		return
		
	floor_ray.force_raycast_update()
	
	if not floor_ray.is_colliding():
		if not default_sound.is_empty():
			play_footstep(default_sound.pick_random())
		return
		
	var collider = floor_ray.get_collider()
	
	if not collider is CollisionObject2D:
		return
		
	var clips: Array[AudioStream] = []
	
	if collider.get_collision_layer_value(1):
		clips = default_sound
		
	elif collider.get_collision_layer_value(2):
		clips = grass_sound
		
	elif collider.get_collision_layer_value(3):
		clips = wood_sound
		
	elif collider.get_collision_layer_value(4):
		clips = stone_sound
	
	else:
		clips = default_sound
	
	if clips.is_empty():
		return
		
	play_footstep(clips.pick_random())

func _ready() -> void:
	add_to_group("player")
	
	var current_scene := get_tree().current_scene
	if (
		GameState.has_saved_position
		and current_scene != null
		and current_scene.scene_file_path == "res://assets/textures/Tileset/MainMap.tscn"
	):
		global_position = GameState.player_position
		var camera := get_node_or_null("Camera2D") as Camera2D
		if camera != null:
			camera.global_position = GameState.camera_position
			camera.reset_smoothing()
		GameState.has_saved_position = false

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	
	var currentspeed := speed
	
	if Input.is_action_pressed("run"):
		
		currentspeed = run_speed
	
	velocity = direction * currentspeed
	
	move_and_slide()
	
	$AnimatedSprite2D.update_animation(
		direction,
		Input.is_action_pressed("run")
	)

	# Footstep timer
	if direction != Vector2.ZERO:
		footstep_timer -= delta
		
		if footstep_timer <= 0.0:
			footstepsound()
			if Input.is_action_pressed("run"):
				footstep_timer = 0.2
			else:	
				footstep_timer = 0.6
	else:
		footstep_timer = 0.0
