extends Area2D


var uturn = true

func _ready():
	$labelss/labels.hide()
	
func labels_set(melee):
	print(melee)
	for i in range(len(melee["melee"])):
		$labelss/labels.get_child(i).text = melee["melee"][i]["name"]
		

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.is_pressed():
        self.on_click()

func on_click():
	$melee.hide()
	get_node("..").get_node("Magic").hide()
	get_node("..").get_node("Wait").hide()
	$labelss/labels.show()
	pass

func _on_Melee_mouse_exited():
	if(uturn):
		$melee.show()
		get_node("..").get_node("Magic").show()
		get_node("..").get_node("Wait").show()
		$labelss/labels.hide()

func button_get_shit(shit):
	for i in $labelss/labels.get_children():
		for j in i.get_children():
			if j is Button:
				if j.pressed:
					if i.text != "":
						calculate_damage(shit,i)
		for k in shit["melee"]:
			if k["name"] == i.text and k["ccooldown"]>0:
				i.get_child(1).text = str(k["tcooldown"]-k["ccooldown"]+1)
			if k["name"] == i.text and k["ccooldown"]==0:
				i.get_child(1).text = ""
	
	pass

func calculate_damage(melee,me):
	
	for i in melee["melee"]:
		if i["name"] == me.text and i["ccooldown"] < 1:
			if uturn:
				
				var damage = i["damage"] * melee["strong"]
				$labelss/labels.hide()
				$melee.hide()
				get_node("..").get_node("Magic").hide()
				
				$"../Audio".stream = i["sfx"]
				$"../Audio".play()
				$"../../Enemy/AnimationPlayer".play("hit")
				yield($"../../Enemy/AnimationPlayer" , "animation_finished" )
				uturn = false
				
				$"..".get_parent().get_node("Enemy").health -= damage
				i["ccooldown"]=1
				me.add_color_override("font_color", Color(0.47,0.47,0.47,1))
				
				if $"..".mana < melee["maxmana"]:
					$"..".mana += 1
					if melee["name"]=="Celea":
						$"..".mana += 1
				
				
				print(damage)
					
			for j in melee["melee"]:
				if j["ccooldown"] > 0:
					j["ccooldown"]+=1
					if j["ccooldown"] > j["tcooldown"]:
						j["ccooldown"]=0
						for k in $labelss/labels.get_children():
							if k.text == j["name"]:
									k.add_color_override("font_color", Color(1,1,1,1))
						
					print("%s cooldown %s" % [j["name"],j["ccooldown"]])
	
	pass

