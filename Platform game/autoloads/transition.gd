extends CanvasLayer


var tween = Tween.new()
var black_cover = ColorRect.new()

func _enter_tree():
	layer = 5

func _ready():
	black_cover.hide()
	black_cover.color = Color(0,0,0,0)
	black_cover.rect_size = get_tree().current_scene.get_viewport().size
	add_child(black_cover)
	add_child(tween)

func transition(scene: String):
	black_cover.show()
	tween.interpolate_property(black_cover, "color", Color(0,0,0,0), Color(0,0,0,1),
	0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	var res = get_tree().change_scene(scene)
	tween.interpolate_property(black_cover, "color", Color(0,0,0,1), Color(0,0,0,0),
	0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	black_cover.hide()
	
	
	
