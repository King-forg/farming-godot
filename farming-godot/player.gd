
extends CharacterBody2D

@export var speed: float = 50.0
@export var run_speed: float = 80.0

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
