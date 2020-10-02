extends Node

var save_data = {
	"current_room" : null,
	"current_checkpoint" : null,

	"shovel_type" : "none",
	"shoe_type" : "none",

	"life_cont_amounts" : 1,
	"life" : 100,
	
	"powerups" : [
		
	]
}

const FILE_NAME = "user://game-data.json"

func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(save_data))
	file.close()

func load():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			save_data = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")

func _ready():
	pass # Replace with function body.


