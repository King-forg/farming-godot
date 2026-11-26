
extends NinePatchRect

@onready var selection:= 1
@onready var selectpos: Vector2 = self.position
var nextpos: Vector2


func _ready() -> void:
	selection = 6
	 # Later on i will make this reference the json


func smooth_transition(target: Vector2, duration: float) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", target, duration)


func scrolldown(nextpos):
	smooth_transition(nextpos, 0.2)
	selection = selection + 1
	selectpos = nextpos


func scrollup(nextpos):
	smooth_transition(nextpos, 0.2)
	selection = selection - 1
	selectpos = nextpos


func _input(event):
	if event.is_action_pressed("scroll_up"):
		if selection > 1:
			if selection == 2:
				nextpos = Vector2(selectpos.x - 31, selectpos.y)
			elif selection == 3:
				nextpos = Vector2(selectpos.x - 32, selectpos.y)
			elif selection == 4:
				nextpos = Vector2(selectpos.x - 31, selectpos.y)
			elif selection == 5:
				nextpos = Vector2(selectpos.x - 31, selectpos.y)
			elif selection == 6:
				nextpos = Vector2(selectpos.x - 31, selectpos.y)

			scrollup(nextpos)

	if event.is_action_pressed("scroll_down"):
		if selection < 6:
			if selection == 1:
				nextpos = Vector2(selectpos.x + 31, selectpos.y)
			elif selection == 2:
				nextpos = Vector2(selectpos.x + 32, selectpos.y)
			elif selection == 3:
				nextpos = Vector2(selectpos.x + 31, selectpos.y)
			elif selection == 4:
				nextpos = Vector2(selectpos.x + 31, selectpos.y)
			elif selection == 5:
				nextpos = Vector2(selectpos.x + 31, selectpos.y)

			scrolldown(nextpos)
