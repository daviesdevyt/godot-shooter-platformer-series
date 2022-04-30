extends KinematicBody2D

onready var screen_shaker = $Camera2D/screen_shaker
var move = Vector2()
var speed = 200
var jump_speed = -400
var grv = 10
var lastdir = 1
var gun = preload("res://objects/gun.tscn")

func _ready():
	if autoload.has_gun and not autoload.just_got_gun:
		var gun_instance = gun.instance()
		gun_instance.global_position = global_position
		add_child(gun_instance)
	for child in get_parent().get_node("powerups").get_children():
		child.connect("player_entered", self, "_powerup")


func _physics_process(delta):
	if not is_on_floor(): move.y += grv
	move.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))*speed
	if sign(move.x) == 0:
		$Sprite.flip_h = lastdir == -1
	elif sign(move.x) == -1:
		lastdir = -1
		$Sprite.flip_h = true
	else:
		lastdir = 1
		$Sprite.flip_h = false
	if move.y < 0: $Sprite.play("jump")
	if move.x != 0: $Sprite.play("run")
	else: $Sprite.play("idle")
	
	if Input.is_action_pressed("ui_up") and is_on_floor():
		move.y = jump_speed
	move_and_slide(move, Vector2.UP)

func kill():
	get_parent().failed()

func next_level():
	autoload.level += 1
	autoload.just_got_gun = !autoload.has_gun
	get_parent().check_highscore()

func pick(item):
	match item:
		"gun":
			var gun_instance = gun.instance()
			gun_instance.global_position = global_position
			add_child(gun_instance)
			autoload.just_got_gun = true
			

func _powerup(type):
	match type:
		1:
			var prev_speed = speed
			speed *= 2
			var prev_jump = jump_speed
			jump_speed *= 2
			yield(get_tree().create_timer(5), "timeout")
			speed = prev_speed
			jump_speed = prev_jump
		0:
			if autoload.has_gun:
				$gun.state = 'shoot_spread'
				yield(get_tree().create_timer(5), "timeout")
				$gun.state = 'shoot'
		
		
		



