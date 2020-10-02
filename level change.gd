extends Area2D

export(PackedScene) var next_level


func _ready():
	pass # Replace with function body.


func _on_level_change_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene_to(next_level)
