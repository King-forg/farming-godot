extends MarginContainer

const SAVE_PATH := "user://userinfo.json"

var newhealth: int
var health: int

@onready var health10 = get_node("Health/Health/Bar/BarVal/100")
@onready var health9 = get_node("Health/Health/Bar/BarVal/90")
@onready var health8 = get_node("Health/Health/Bar/BarVal/80")
@onready var health7 = get_node("Health/Health/Bar/BarVal/70")
@onready var health6 = get_node("Health/Health/Bar/BarVal/60")
@onready var health5 = get_node("Health/Health/Bar/BarVal/50")
@onready var health4 = get_node("Health/Health/Bar/BarVal/40")
@onready var health3 = get_node("Health/Health/Bar/BarVal/30")
@onready var health2 = get_node("Health/Health/Bar/BarVal/20")
@onready var health1 = get_node("Health/Health/Bar/BarVal/10")
@onready var health0 = get_node("Health/Health/Bar/BarVal/0")

func _ready() -> void:
	fileread()
	healthchange(health)

func fileread() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var jsonstring = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(jsonstring)
		if error == OK:
			var data_recieved = json.data
			if typeof(data_recieved) == TYPE_DICTIONARY:
				var health = data_recieved["health"]
				newhealth = health			
			else:
				var data_to_send = {
					"health": 100
				}	
				var json_string = JSON.stringify(data_to_send)
				file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
				file.store_string(json_string)
				file.close()

func filewrite(place,data) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var save_game = FileAccess.open(SAVE_PATH,FileAccess.READ)
		var json = JSON.new()
		json.parse(save_game.get_as_text())
		save_game.close()
		var current_scene_dict = json.data
		current_scene_dict[place] = data
		save_game = FileAccess.open(SAVE_PATH,FileAccess.WRITE)
		save_game.store_line(JSON.stringify(current_scene_dict))
		save_game.close()

func healthchange(healthnum) -> void:
	if healthnum == 0:
		health10.hide()
		health9.hide()
		health8.hide()
		health7.hide()
		health6.hide()
		health5.hide()
		health4.hide()
		health3.hide()
		health2.hide()
		health1.hide()
		health0.show() 
		
	elif healthnum == 1:
		health10.hide()
		health9.hide()
		health8.hide()
		health7.hide()
		health6.hide()
		health5.hide()
		health4.hide()
		health3.hide()
		health2.hide()
		health1.show()
		health0.show()
		
	elif healthnum == 2:
		health10.hide()
		health9.hide()
		health8.hide()
		health7.hide()
		health6.hide()
		health5.hide()
		health4.hide()
		health3.hide()
		health2.show()
		health1.show()
		health0.show()

	elif healthnum == 3:
		health10.hide()
		health9.hide()
		health8.hide()
		health7.hide()
		health6.hide()
		health5.hide()
		health4.hide()
		health3.show()
		health2.show()
		health1.show()
		health0.show()

	elif healthnum == 4:
		health10.hide()
		health9.hide()
		health8.hide()
		health7.hide()
		health6.hide()
		health5.hide()
		health4.show()
		health3.show()
		health2.show()
		health1.show()
		health0.show()

	elif healthnum == 5:
		health10.hide()
		health9.hide()
		health8.hide()
		health7.hide()
		health6.hide()
		health5.show()
		health4.show()
		health3.show()
		health2.show()
		health1.show()
		health0.show()

	elif healthnum == 6:
		health10.hide()
		health9.hide()
		health8.hide()
		health7.hide()
		health6.show()
		health5.show()
		health4.show()
		health3.show()
		health2.show()
		health1.show()
		health0.show()

	elif healthnum == 7:
		health10.hide()
		health9.hide()
		health8.hide()
		health7.show()
		health6.show()
		health5.show()
		health4.show()
		health3.show()
		health2.show()
		health1.show()
		health0.show()

	elif healthnum == 8:
		health10.hide()
		health9.hide()
		health8.show()
		health7.show()
		health6.show()
		health5.show()
		health4.show()
		health3.show()
		health2.show()
		health1.show()
		health0.show()

	elif healthnum == 9:
		health10.hide()
		health9.show()
		health8.show()
		health7.show()
		health6.show()
		health5.show()
		health4.show()
		health3.show()
		health2.show()
		health1.show()
		health0.show()

	elif healthnum == 10:
		health10.show()
		health9.show()
		health8.show()
		health7.show()
		health6.show()
		health5.show()
		health4.show()
		health3.show()
		health2.show()
		health1.show()
		health0.show()

func _process(delta: float) -> void:
	if health != newhealth:
		health = newhealth
		filewrite("health", health)
		healthchange(health)
