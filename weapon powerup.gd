extends Area2D


export(String, "Shovel", "Shoe", "Life") var itemType = "Shovel"
export(String, "Basic", "Power", "Super") var itemGrade = "Basic"
export var id : String

var SpriteLists = {
	"Shovel" : {
		"Basic" : load("res://sprites/bad shovel.png")
	},
	"Shoe" : {
		"Basic" : load("res://sprites/slightly better shoes.png")
	},
	"Life" : {
		"Basic" : null
	}
}

func _ready():
	$Sprite.texture = SpriteLists[itemType][itemGrade]
	$Label.text = "YOU GOT A \n %s %s" % [itemGrade.to_upper(), itemType.to_upper()]
	if global.save_data["powerups"].has(id): queue_free()


func _on_weapon_powerup_body_entered(body):
	if body.name == "Player":
		print("lmao %s" % itemType)
		match itemType:
			"Shovel":
				print("shovv")
				if global.save_data["shovel_type"] != itemGrade:
					global.save_data["shovel_type"] = itemGrade
				else: queue_free()

			"Shoe":
				print("shoesh")
				if global.save_data["shoe_type"] != itemGrade:
					global.save_data["shoe_type"] = itemGrade
				else: queue_free()
				$"../Player".update_equipment()
				print("s h o e")

		get_tree().paused = true
		$Label.visible = true
		$AudioStreamPlayer.play()
		yield($AudioStreamPlayer, "finished")
		get_tree().paused = false
		$"../Player".update_equipment()
		global.save_data["powerups"].append(id)
		queue_free()
