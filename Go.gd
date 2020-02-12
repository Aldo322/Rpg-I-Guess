extends Button

var turn = 0
var i1 = 0
var i2 = 0


func _ready():
	pass

func augmento():
	turn += 1
	print(turn)

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		if turn > 0:
			turn = 0
			$"../help1".texture = null
			$"../help1/Name".text = "" 
			$"../help2".texture = null
			$"../help2/Name".text = "" 
			for i in $"../fullroster".get_children():
				i.disabled = false
				i.shit = false
			print(turn)
	if turn > 1:
		disabled = false
	else:
		disabled = true
	if pressed:
		print(i1)
	
		# Add the next level
		var next_level_resource = load("res://fight_pve.tscn")
		var next_level = next_level_resource.instance()
		get_node("/root").add_child(next_level)
		
		var p = get_node("/root").get_child(2).get_node("Player")
		var e = get_node("/root").get_child(2).get_node("Enemy")
		p.doload(i1)
		e.doload(i2)
		
		# Remove the current level
		var level =  get_parent()
		get_node("/root").remove_child(level)
		level.call_deferred("free")
		
		