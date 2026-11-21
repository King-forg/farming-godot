
extends CharacterBody2D

@export var speed: float = 50.0
@export var run_speed: float = 80.0

func _ready() -> void:
	add_to_group("player")

	var current_scene := get_tree().current_scene
	if (
		GameState.has_saved_position
		and current_scene != null
		and current_scene.scene_file_path == "res://assets/textures/Tileset/MainMap.tscn"
	):
		global_position = GameState.player_position
		GameState.has_saved_position = false

func _physics_process(delta):
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	var currentspeed = speed

	if Input.is_action_pressed("run"):
		currentspeed = run_speed
	
	velocity = direction * currentspeed
	move_and_slide()

	$AnimatedSprite2D.update_animation(
		direction,
		Input.is_action_pressed("run")
	)
