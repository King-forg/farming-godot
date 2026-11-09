extends CharacterBody2D

@export var speed = 200.0

@onready var sprite = $AnimatedSprite2D

var last_direction = "down"


func _physics_process(delta):
	
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
		velocity = direction  * speed
		move_and_slide()
		
		if direction != Vector2.ZERO:
			
			if abs(direction.x) > abs(direction.y):
				last_direction = "side"
				sprite.flip_h = direction.x < 0
				
			elif direction.y < 0:
				last_direction = "up"
			
			else:
				last_direction = "down"
				
			sprite.play(last_direction)
		
		else:
			sprite.stop()
			sprite.frame = 0
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
