extends Node2D

var scores = []
var kills = 0
var http_get = HTTPRequest.new()
var http_post = HTTPRequest.new()

func _ready():
	add_child(http_get)
	http_get.request(autoload.highscore_api)
	http_get.connect("request_completed", self, "_request")
	add_child(http_post)
	http_post.connect("request_completed", self, "_req")

func _add_point():
	kills += 1
	$BG/Label.kills += 1

func failed():
	$ui.failed()

func _request(result, response_code, headers, body):
	var data = JSON.parse(body.get_string_from_utf8()).result
	if data == null:
		return
	data = parse_json(data)
	for i in data:
		scores.append(i.score)
	scores.sort()
	scores.invert()
	for i in scores:
		for ii in data:
			if i == ii.score:
				autoload.leaderboard.append(ii)


func check_highscore():
	if scores.empty() or kills > scores.back():
		if !scores.empty():
			autoload.leaderboard.pop_back()
		var payload = {"name": autoload._name, 'score': kills}
		autoload.leaderboard.push_front(payload)
		var query = {"file_name": "highscores", "file_data": JSON.print(autoload.leaderboard)}
		query = JSON.print(query)
		print(query)
		var headers = ["Content-Type: application/json"]
		http_post.request(autoload.highscore_api,
		headers, true, HTTPClient.METHOD_POST, query)
		yield(http_post, "request_completed")
		Transition.transition("res://levels/Game"+str(autoload.level)+".tscn")

func _req(result, response_code, headers, body):
	print(response_code)
