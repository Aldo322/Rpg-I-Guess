extends KinematicBody2D

var run_speed = 100
var velocity = Vector2.ZERO
var player = null
var health = 15
var damage = 15

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * run_speed
	velocity = move_and_slide(velocity)

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		player = body

func _on_DetectRadius_body_exited(body):
	if body.name == "Player":
		player = null


func _on_Hitbox_body_entered(body):
	if body.name == "Player":
		body.hurt(damage, self)
