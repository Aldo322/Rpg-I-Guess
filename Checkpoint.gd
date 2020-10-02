extends Area2D


var player_in = false
var active = false

func _ready():
	pass # Replace with function body.

func _process(delta):

	if player_in:
		if Input.is_action_pressed("shovel"):
			var scene = get_tree().current_scene.filename
			global.save_data["current_room"] = scene
			global.save_data["current_checkpoint"] = get_path()
			global.save()
			$CPUParticles2D.emitting = true



func _on_Checkpoint_body_entered(body):
	if body.name == "Player":
		player_in = true
		$Label.visible = true
		

func _on_Checkpoint_body_exited(body):
	if body.name == "Player":
		player_in = false
		$Label.visible = false
