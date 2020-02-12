extends Node2D


var burn = {"type":"fire","category":"damage","damage":2,"duration":3}
var freeze = {"type":"ice","category":"block","duration":3}
var heal = {"type":"light","category":"heal","heal":10}


# warning-ignore:unused_class_variable
var fire = {"name":"Fire", "type":"fire", "category":"magic","manacost":4, "damage":6, "effect":burn, "sfx":preload("res://Sounds/Fire impact 1.wav")}
# warning-ignore:unused_class_variable
var ice_storm = {"name":"Ice storm", "type":"ice", "category":"magic","manacost":2, "damage":5, "effect":freeze, "sfx":preload("res://Sounds/Ice attack 2.wav")}
# warning-ignore:unused_class_variable
var fire_ball = {"name":"Fire Ball", "type":"fire", "category":"magic","manacost":2, "damage":3, "sfx":preload("res://Sounds/Waving Torch.wav")}
# warning-ignore:unused_class_variable
var water_ball = {"name":"Water Ball", "type":"water", "category":"magic","manacost":2, "damage":3, "sfx":preload("res://Sounds/Spell/water.wav")}
# warning-ignore:unused_class_variable
var light_ball = {"name":"Heal", "type":"heal", "category":"magic","manacost":3, "damage":0, "effect":heal, "sfx":preload("res://Sounds/Healing Full.wav")}
# warning-ignore:unused_class_variable
var dark_ball = {"name":"Dank Ball", "type":"dark", "category":"magic","manacost":2, "damage":3, "sfx":preload("res://Sounds/Spell/enchant2.wav")}
# warning-ignore:unused_class_variable
var sword1 = {"name":"Sword thing", "type":"none", "category":"melee", "tcooldown":2, "ccooldown":0, "damage":3, "sfx":preload("res://Sounds/sword sound.wav")}
# warning-ignore:unused_class_variable
var sword2 = {"name":"Power Sword thing", "type":"none", "category":"melee", "tcooldown":3, "ccooldown":0, "damage":10, "sfx":preload("res://Sounds/sword sound.wav")}
# warning-ignore:unused_class_variable
var nyeh = {"name":"IDK", "type":"none", "category":"melee", "tcooldown":0, "ccooldown":0, "damage":3, "sfx":preload("res://Sounds/animal melee sound.wav")}


# warning-ignore:unused_class_variable
var sword_melee = [sword1,sword2]
# warning-ignore:unused_class_variable
var nyyyeh = [nyeh]

# warning-ignore:unused_class_variable
var luvian_magic = [ice_storm]
# warning-ignore:unused_class_variable
var illiria_magic = [fire]
# warning-ignore:unused_class_variable
var celea_magic = [fire_ball,water_ball,light_ball,dark_ball]

# warning-ignore:unused_class_variable
var illiria_dat = {"name":"Illiria", "sprite":preload("res://sprite/Illiria_icon.png"), "maxhp":100, "maxmana":10, "type":"fire","melee":sword_melee,"magic":illiria_magic,"strong":2, "win":["yare yare daze"], "lose":["fuck"]}
# warning-ignore:unused_class_variable
var luvian_dat = {"name":"Luvian", "sprite":preload("res://sprite/Luvian_icon.png"), "maxhp":101, "maxmana":9,"type":"ice","melee":sword_melee,"magic":luvian_magic,"strong":2, "win":["placeholder fuck"], "lose":["fuck"]}
# warning-ignore:unused_class_variable
var celea_dat = {"name":"Celea", "sprite":preload("res://sprite/Celea_icon.png"), "maxhp":60, "maxmana":6,"type":"none","melee":nyyyeh,"magic":celea_magic,"strong":1.5, "win":["yay"], "lose":["fuck"]}

var characters = [illiria_dat, luvian_dat, celea_dat]

var ready
var current = characters[0]
# warning-ignore:unused_class_variable
var health = 0
# warning-ignore:unused_class_variable
var mana = 0

signal exist

func doload(i):
	print("hoy")
	current = characters[i]
	health = current.get("maxhp")
	print(health)
	mana = current.get("maxmana")
	print(mana)
	$IconS.texture=current.get("sprite")
	print(current.get("sprite"))
	$Labels/Name .text = current.get("name")
	$Labels/HP.text = "HP:%s/%s" % [health,current.get("maxhp")]
	$Labels/Mana.text = "MP:%s/%s" % [mana,current.get("maxmana")]
	
	$Melee.labels_set(current)
	$Magic.labels_set(current)
	ready = true
	print(ready)




func _process(delta):
	if ready:
		$Melee.button_get_shit(current)
		$Magic.button_get_shit(current)
		$Labels/HP.text = "HP:%s/%s" % [health,current.get("maxhp")]
		$Labels/Mana.text = "MP:%s/%s" % [mana,current.get("maxmana")]
		if health < 1:
			ready = false
			$"../VideoPlayer".show()
			for i in $Labels.get_children():
				i.hide()
			for i in $"../Enemy/Labels".get_children():
				i.hide()
			$"../VideoPlayer".play()
			yield($"../VideoPlayer","finished")
			$"../end".show()
			$"../end/winnerl".text = $"../Enemy".current["name"]
			$"../end/loserl".text = current["name"]
			$"../end/winnertext".text = $"../Enemy".current["win"][0]
			$"../end/losertext".text = current["lose"][0]
			yield(get_tree().create_timer(4),"timeout")
			$"../end/buttons".show()
		if $"../Enemy".health < 1:
			ready = false
			$WIN.show()
			for i in $Labels.get_children():
				i.hide()
			for i in $"../Enemy/Labels".get_children():
				i.hide()
			$"../Music".play()
			yield(get_tree().create_timer(4),"timeout")
			$"../end".show()
			$"../end/winnerl".text = current["name"]
			$"../end/loserl".text = $"../Enemy".current["name"]
			$"../end/winnertext".text = current["win"][0]
			$"../end/losertext".text = $"../Enemy".current["lose"][0]
			yield(get_tree().create_timer(4),"timeout")
			$"../end/buttons".show()

func _on_Replay_pressed():
	get_tree().reload_current_scene()

func _on_char_pressed():
	var next_level_resource = load("res://roster i guess.tscn")
	var next_level = next_level_resource.instance()
	get_node("/root").add_child(next_level)
	# Remove the current level
	var level =  get_parent()
	get_node("/root").remove_child(level)
	level.call_deferred("free")

func _on_menu_pressed():
	var next_level_resource = load("res://Main menu (i guess).tscn")
	var next_level = next_level_resource.instance()
	get_node("/root").add_child(next_level)
	# Remove the current level
	var level =  get_parent()
	get_node("/root").remove_child(level)
	level.call_deferred("free")
