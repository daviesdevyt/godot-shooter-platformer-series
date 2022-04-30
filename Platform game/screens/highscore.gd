extends Panel


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	if data == null:
		show()
		$container/highscores/unable_to_connect.show()
		return
	data = parse_json(data)
	var hs = $container/highscores
	var scores = []
	for i in data:
		scores.append(i.score)
	scores.sort()
	scores.invert()
	for i in scores:
		for ii in data:
			if i == ii.score:
				autoload.leaderboard.append(ii)
				var new = hs.get_node("entity").duplicate()
				new.get_node('name').text = ii.name
				new.get_node('score').text = str(ii.score)
				new.show()
				hs.add_child(new)
	show()

func _on_close_pressed():
	hide()
