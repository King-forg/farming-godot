extends Area2D

@export var message_label: Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	find_message_label()

func find_message_label() -> void:
	if message_label != null:
		return

	message_label = get_tree().get_first_node_in_group("bottom_prompt") as Label

func _process(_delta: float) -> void:
	if message_label == null:
		find_message_label()

	if message_label != null and message_label.visible:
		if Input.is_action_just_pressed("interact"):
			var player := get_tree().get_first_node_in_group("player") as Node2D
			if player != null:
				GameState.player_position = player.global_position
				GameState.has_saved_position = true
				var camera := get_viewport().get_camera_2d()
				if camera != null:
					GameState.camera_position = camera.global_position
			get_tree().change_scene_to_file("res://house_thing.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if message_label != null:
			message_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		if message_label != null:
			message_label.visible = false
