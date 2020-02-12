extends Node2D


var current

var health 
var mana

func doload(index):
	current = $"../Player".characters[index]
	health = current.get("maxhp")
	mana = current.get("maxmana")
	
	$IconS.texture=current.get("sprite")
	$IconS.flip_h=true
	$Labels/Name .text = current.get("name")
	$Labels/HP.text = "HP:%s/%s" % [health,current.get("maxhp")]
	$Labels/Mana.text = "MP:%s/%s" % [mana,current.get("maxmana")]
	if name!="Enemy":
		$Melee.labels_set(current)
		$Magic.labels_set(current)

func _process(delta):
	if name!="Enemy":
		$Melee.button_get_shit(current)
	$Labels/HP.text = "HP:%s/%s" % [health,current.get("maxhp")]
	$Labels/Mana.text = "MP:%s/%s" % [mana,current.get("maxmana")]
	if !$"../Player/Melee".uturn:
		$"../Player/Melee".uturn = true
		yield(get_tree().create_timer(0.5), "timeout")
		$"../Player".get_node("Audio").stream = current["melee"][0]["sfx"]
		$"../Player".get_node("Audio").play()
		$"../Player/AnimationPlayer".play("hit")
		$"../Player".health -= current["melee"][0]["damage"] * current["strong"]
		
	