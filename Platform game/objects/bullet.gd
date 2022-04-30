extends Area2D


export var speed = 1500

func _ready():
	set_as_toplevel(true)

func _process(delta):
	position += (Vector2.RIGHT*speed).rotated(rotation) * delta

func _physics_process(delta):
	yield(get_tree().create_timer(0.01), "timeout")
	$Sprite.frame = 1
	set_physics_process(false)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_bullet_body_entered(body):
	if self.name == "enemy_bullet" and body.name == "player":
		body.kill()
	if not (body.is_a_parent_of(self) or body.get_parent() == get_parent()):
		queue_free()

func _on_enemy_bullet_area_entered(area):
	_on_bullet_body_entered(area)
	

