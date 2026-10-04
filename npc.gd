extends StaticBody2D

var is_player_in_range = false
var dialogue_lines = []
var current_line_index = 0

func _ready():
	$InteractionArea.body_entered.connect(_on_body_entered)
	$InteractionArea.body_exited.connect(_on_body_exited)
	load_dialogue_file("res://text/npc_dialogue.txt")

func load_dialogue_file(path):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			if line != "":
				dialogue_lines.append(line)
		print("テキスト読込成功。行数: ", dialogue_lines.size())
	else:
		print("【エラー】テキストファイルが見つかりません: ", path)

func _on_body_entered(body):
	if body.name == "Player":
		is_player_in_range = true
		current_line_index = 0
		print("プレイヤーが範囲に入りました。スペースキーを押してください。")

func _on_body_exited(body):
	if body.name == "Player":
		is_player_in_range = false
		var labels = get_tree().get_nodes_in_group("messages")
		if labels.size() > 0:
			labels[0].text = ""

func _input(event):
	if is_player_in_range and event.is_action_pressed("ui_accept"):
		print("スペースキーが押されました！")
		talk()

func talk():
	var labels = get_tree().get_nodes_in_group("messages")
	if labels.size() == 0:
		print("【エラー】 'messages' グループのラベルが見つかりません！")
		return
	
	if dialogue_lines.size() == 0:
		print("【エラー】 読み込んだセリフが0行です！")
		return
	
	labels[0].text = "(" + dialogue_lines[current_line_index] + ")"
	print("テキストを表示しました: ", labels[0].text)
	current_line_index = (current_line_index + 1) % dialogue_lines.size()
