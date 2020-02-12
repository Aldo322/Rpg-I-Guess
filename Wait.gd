extends Area2D

var mana = 6

func _input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.is_pressed():
        self.on_click()
		
func on_click():
	$"../Melee".uturn = false
	if $"..".mana < $"..".current["maxmana"]:
					$"..".mana += 1
					if $"..".current["name"]=="Celea":
						$"..".mana += 1
	for j in $"..".current["melee"]:
				if j["ccooldown"] > 0:
					j["ccooldown"]+=1
					if j["ccooldown"] > j["tcooldown"]:
						j["ccooldown"]=0
						for k in $"../Melee/labelss/labels".get_children():
							if k.text == j["name"]:
									k.add_color_override("font_color", Color(1,1,1,1))