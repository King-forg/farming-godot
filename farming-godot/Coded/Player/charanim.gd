extends AnimatedSprite2D

var last_direction = "forward"

func update_animation(direction, running):

	if direction != Vector2.ZERO:

		if abs(direction.x) > abs(direction.y):
			last_direction = "right"
			flip_h = direction.x < 0

		elif direction.y < 0:
			last_direction = "backward"
			flip_h = false

		else:
			last_direction = "forward"
			flip_h = false

		var animation_name = ""

		if running:
			animation_name = "run-" + last_direction
		else:
			animation_name = "walk-" + last_direction

		if animation != animation_name:
			play(animation_name)

	else:
		match last_direction:
			"backward":
				play("idle-backward")
			"forward":
				play("idle-forward")
			"right":
				play("idle-right")
