extends AnimatedSprite2D

var last_driection = "down"

# Called when the node enters the scene tree for the first time.
func update_animation(direction: Vector2):
	
	if direction != Vector2.ZERO:
		
		if abs(direction.x) > abs(direction.y):
			last_driection = "left" if direction.x < 0 else "right"
			
		elif direction.y < 0:
			last_driection = "up"
			
		else:
			last_driection = "down"
		
		flip_h = direction.x > 0

		
		var animationname = "walk-" + last_driection
		
		if sprite_frames.has_animation(animationname):
			play(animationname)

		elif direction.x != 0 and sprite_frames.has_animation("walk-left"):
			play("walk-left")

		elif sprite_frames.has_animation("walk-down"):
			play("walk-down")

		elif sprite_frames.has_animation("walk-up"):
			play("walk-up")
			
	else:
		stop()
		frame = 0
