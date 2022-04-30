extends CanvasLayer


func _unhandled_key_input(event):
	if event.is_action_released("ui_select"):
		get_tree().paused = true
		$pause/ui.show()


func _on_continue_pressed():
	get_tree().paused = false
	$pause/ui.hide()


func _on_restart_pressed():
	get_tree().paused = false
	autoload.has_gun = !autoload.just_got_gun
	get_tree().reload_current_scene()

func failed():
	$failed/ui.show()

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://screens/menu.tscn")
