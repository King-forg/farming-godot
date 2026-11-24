extends MarginContainer

const SAVE_PATH := "user://userinfo.json"
var file = FileAccess.open(SAVE_PATH, FileAccess.READ)

var newhealth: int
var health: int

func fileread() -> void:
	if file:
		var jsonstring = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(jsonstring)
		if error == OK:
			var data_recieved = json.data
			if typeof(data_recieved) == TYPE_DICTIONARY:
				var health = data_recieved["health"]
				file.close()
			else:
				var data_to_send = {
					"health": 100
				}	
				var json_string = JSON.stringify(data_to_send)
				var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
				file.store_string(json_string)
				file.close()

func filewrite(place,data) -> void:
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

func _process(delta: float) -> void:
	if health != newhealth:
		filewrite("health",newhealth)
		health = newhealth
	
