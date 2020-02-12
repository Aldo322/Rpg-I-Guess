extends Button

export var index = 0
export var sprite = preload("res://sprite/Illiria_icon.png")
var shit = false

func _on_mouse_entered():
	if $"../../../Go".turn==0:
		$"../../../help1".texture = sprite
		$"../../../help1/Name".text = name 
	if $"../../../Go".turn==1:
		$"../../../help2".texture = sprite
		$"../../../help2/Name".text = name 
	
	
func _on_mouse_exited():
	if !shit:
		if $"../../../Go".turn==0:
			$"../../../help1".texture = null
			$"../../../help1/Name".text = "" 
		if $"../../../Go".turn==1:
			$"../../../help2".texture = null
			$"../../../help2/Name".text = "" 
func _process(delta):
	if pressed:
		if !shit:
			if $"../../../Go".turn==0:
				$"../../../Go".turn = 1
				print($"../../../Go".turn)
				$"../../../Go".i1 = index
				disabled = true
				shit = true
		if !shit:
			if $"../../../Go".turn==1:
				$"../../../Go".turn = 2
				print($"../../../Go".turn)
				$"../../../help2".texture = sprite
				$"../../../help2/Name".text = name 
				$"../../../Go".i2 = index
				disabled = true
				shit = true
		