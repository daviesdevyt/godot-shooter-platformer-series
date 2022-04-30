extends KinematicBody2D

export var speed = 130
onready var tilemap = get_tree().current_scene.get_node("TileMap")
export var flip = false
var move = Vector2(speed, 0)
export var hitpoints = 4
var dead_enemy = preload("res://objects/dead_enemy.tscn")
export var has_gun = true

func _ready():
	if !has_gun:
		$gun.queue_free()

func dir_changed():
	flip = !flip
	$sprite.flip_h = flip
	$obj_detect.rotation_degrees = 180 if flip else 0
	move.x *= -1

func _physics_process(delta):
	if not is_on_floor():
		move.y += 10
	if !flip:
		var tile = tilemap.world_to_map(global_position + Vector2(16,32))
		check_wall(tile)
	else:
		var tile = tilemap.world_to_map(global_position + Vector2(-16,32))
		check_wall(tile)
	
	move_and_slide(move, Vector2.UP)

func check_wall(tile):
	var tile_info = tilemap.get_cellv(tile)
	if tile_info == -1:
		dir_changed()


func _on_obj_detect_body_entered(body):
	dir_changed()


func _on_hurtbox_area_entered(area):
	if area.is_in_group("player_bullet"):
		hitpoints -= 1
		$anim.play("flash")
		if hitpoints == 0:
			var dead = dead_enemy.instance()
			dead.global_position = position
			dead.rotation = area.rotation
			dead.apply_central_impulse((Vector2.RIGHT*200).rotated(dead.rotation))
			get_parent().add_child(dead)
			queue_free()


func _exit_tree():
	get_tree().current_scene._add_point()
