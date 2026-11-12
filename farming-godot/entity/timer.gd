extends CharacterBody2D

@export var speed: float = 10.0
var move_direction: Vector2 = Vector2.ZERO

@onready var timer: Timer = $Timer

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	pickrandomdirection()
	
func _physics_process(delta):
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	
	sprite.update_animation(move_direction)
	
	velocity = move_direction * speed
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		pickrandomdirection()
		
func pickrandomdirection() -> void:
	var randomx = randf_range(-1.0, 1.0)
	var randomy = randf_range(-1.0, 1.0)
	move_direction = Vector2(randomx, randomy).normalized()
	
	if randf() < 0.3:
		move_direction = Vector2.ZERO
		
	timer.wait_time = randf_range(1.0, 3.0)
	timer.start()

func _on_timer_timeout() -> void:
	pickrandomdirection()
