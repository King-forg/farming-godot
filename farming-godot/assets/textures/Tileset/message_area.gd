extends Area2D

@export var message_label: Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if message_label == null:
		message_label = get_tree().current_scene.get_node_or_null(
			"CanvasLayer/BottomPrompt/Label"
		) as Label


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if message_label != null:
			message_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		if message_label != null:
			message_label.visible = false
