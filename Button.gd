extends Button


func _on_Button_button_down():
	global.load()
	if global.save_data["current_room"] != null:
		get_tree().change_scene(global.save_data["current_room"])
	else: 
		print("no save :(")
		print("creating save...")
		global.save()
		get_tree().change_scene("res://test scene.tscn")
