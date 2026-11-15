@tool
extends EditorScript

func _run():
	var path = "res://Farm RPG/UI/0.2.png"
	var output = "res://Farm RPG/UI/0.2_UPSC.png"
	
	
	var image = Image.load_from_file(path)
	
	if image.is_empty():
		print("Failed to process")
		return
		
	image.resize(2400, 640, Image.INTERPOLATE_NEAREST)
	
	var error = image.save_png(output)
	
	if error == OK:
		print("Success", output)
	else:
		print("Fail", error)
