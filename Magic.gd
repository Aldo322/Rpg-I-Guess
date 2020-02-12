extends Area2D


 

func _ready():
	$labelss/labels.hide()
	
func labels_set(magic):
	print(magic)
	for i in range(len(magic["magic"])):
		$labelss/labels.get_child(i).text = magic["magic"][i]["name"]
		for k in $labelss/labels.get_children():
			for j in magic["magic"]:
				if j["name"] == k.text:
					k.get_child(1).text = str(j["manacost"])

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.is_pressed():
        self.on_click()

func on_click():
	$magic.hide()
	get_node("..").get_node("Melee").hide()
	get_node("..").get_node("Wait").hide()
	$labelss/labels.show()
	pass

func _on_Magic_mouse_exited():
	$magic.show()
	get_node("..").get_node("Melee").show()
	get_node("..").get_node("Wait").show()
		
	$labelss/labels.hide()

func button_get_shit(shit):
	for i in $labelss/labels.get_children():
		for j in i.get_children():
			if j is Button:
				if j.pressed:
					if i.text != "":
						calculate_damage(shit,i)
					
		for k in shit["magic"]:
			if $"..".mana < k["manacost"] and k["name"] == i.text:
				i.add_color_override("font_color", Color(0.47,0.47,0.47,1))
				i.get_child(1).add_color_override("font_color", Color(0.56,0.21,0.21,1))
			if $"..".mana >= k["manacost"] and k["name"] == i.text:
				i.add_color_override("font_color", Color(1,1,1,1))
				i.get_child(1).add_color_override("font_color", Color(0.21,0.78,1,1))
			
		
	pass
	
func calculate_damage(magic,me):
	for i in magic["magic"]:
		if $"..".mana >= i["manacost"]:
			if i["name"] == me.text:
				if $"../Melee".uturn:
					
					var damage = i["damage"] * magic["strong"]
					print(damage)
					if i["type"]=="fire" and $"../../Enemy".current["type"]=="ice":
						damage += damage*1.5
					if i["type"]=="water" and $"../../Enemy".current["type"]=="fire":
						damage += damage*1.5
					$labelss/labels.hide()
					$magic.hide()
					get_node("..").get_node("Melee").hide()
					
					$"../Audio".stream = i["sfx"]
					$"../Audio".play()
					if i["type"]=="fire":
						$"../../Enemy/AnimationPlayer".play("Fire")
						$"../Melee".uturn = false
					if i["type"]=="water":
						$"../../Enemy/AnimationPlayer".play("Water")
						$"../Melee".uturn = false
					if i["type"]=="heal":
						$"../AnimationPlayer".play("Heal")
						yield($"../AnimationPlayer" , "animation_finished" )
						$"../Melee".uturn = false
					if i["type"]=="ice":
						$"../../Enemy/AnimationPlayer".play("Ice")
						yield($"../AnimationPlayer" , "animation_finished" )
						if i.has("effect"):
							if i["effect"]["category"] == "freeze":
								$"../Melee".uturn = true
							else:
								$"../Melee".uturn = false
						else:
							$"../Melee".uturn = false
								
					
					
					$"..".get_parent().get_node("Enemy").health -= round(damage)
					
					if i.has("effect"):
						if i["effect"]["category"] == "heal":
							$"..".health += i["effect"]["heal"]
					
					$"..".mana -= i["manacost"]
					print(damage)
		
		for j in magic["melee"]:
				if j["ccooldown"] > 0:
					j["ccooldown"]+=1
					if j["ccooldown"] > j["tcooldown"]:
						j["ccooldown"]=0
						for k in $"../../Player/Melee/labelss/labels".get_children():
							if k.text == j["name"]:
									k.add_color_override("font_color", Color(1,1,1,1))
			
	pass

