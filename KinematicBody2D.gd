extends KinematicBody2D


var has_shovel = false
var total_life_cont_amounts = 1
var life_cont_amounts = 1
var life = 100

onready var state_machine = $AnimationTree.get("parameters/playback")
onready var UI = $"../CanvasLayer/Ui"

export (int) var run_speed = 100
export (int) var jump_speed = -250
export (int) var gravity = 1200

var velocity = Vector2()
var jumping = false
var face_left = false
var input_on = true
var enemy_touching = false
var touching_enemy : Node

func _ready():
	update_equipment()
	if global.save_data["current_room"] == get_tree().current_scene.filename and global.save_data["current_checkpoint"] != null:
		position = get_parent().get_node(global.save_data["current_checkpoint"]).position
			
func update_equipment():
	match global.save_data["shovel_type"]:
		"Basic": 
			has_shovel = true 
			$"shovel sprite".visible = true
	match global.save_data["shoe_type"]:
		"Basic":
			jump_speed = -500
			$"shoe sprite".visible = true
	if global.save_data["life_cont_amounts"] != total_life_cont_amounts :
		total_life_cont_amounts = global.save_data["life_cont_amounts"]
		life = 100 * total_life_cont_amounts
		life_cont_amounts = total_life_cont_amounts
		for i in UI.get_node("VBoxContainer/HBoxContainer/Life"):
			if i.visible != true:
				i.visible = true
	print("equipment updated")
	
func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select')
	var shovel = Input.is_action_just_pressed("shovel")
	var save_db = Input.is_action_just_pressed("debug_save")

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
		state_machine.travel("jump")
		$AudioStreamPlayer.stream = load("res://sfx/jump.wav")
		$AudioStreamPlayer.play()
	if right:
		velocity.x += run_speed
		face_left = false
		$Sprite.flip_h = false
		$"shovel sprite".flip_h = false
		$"shoe sprite".flip_h = false
		state_machine.travel("walk")
	if left:
		velocity.x -= run_speed
		face_left = true
		$Sprite.flip_h = true
		$"shovel sprite".flip_h = true
		$"shoe sprite".flip_h = true
		state_machine.travel("walk")
	if velocity == Vector2(0, 0) and is_on_floor():
		state_machine.travel("idle")
		
	if shovel and has_shovel:
		print("shvl")
		state_machine.travel("shovel")
		var cellpos
		var tilemap = $"../TileMap"
		match face_left:
			false:
				cellpos = tilemap.world_to_map(global_position/1.5) + Vector2(1, 0)
			true:
				cellpos = tilemap.world_to_map(global_position/1.5) + Vector2(-1, 0)
		print(cellpos)
		if tilemap.get_cellv(cellpos) == 60:
			print("shovlvl")
			$ShovelParticles.emitting = true
			tilemap.set_cellv(cellpos, -1)
			$"../Front Layer Tilemap".set_cellv(cellpos, -1)
		
		
	if save_db:
		save()

func _physics_process(delta):
	if input_on: get_input()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity, Vector2(0, -1))
	$"../Camera2D".position = position

func save():
	print("saev")
	var scene = get_tree().current_scene.filename
	global.save_data["current_room"] = scene
	global.save()


func hurt(damage, enemy):
	life -= damage
	
	if enemy.position.x > position.x:
		velocity.x = -200
	elif enemy.position.x < position.x:
		velocity.x = 200
	
	if life > 0:
		var current_life = UI.get_node("VBoxContainer/HBoxContainer/Life").get_child(life_cont_amounts-1)
		if current_life.value > damage:
			current_life.value -= damage
		else:
			current_life.value = 0
			life_cont_amounts -= 1





func _on_shovel_collision_body_entered(body):
	if body.name == "Enemy":
		enemy_touching = true
		touching_enemy = body

func _on_shovel_collision_body_exited(body):
	if body.name == "Enemy":
		enemy_touching = false
		touching_enemy = null
