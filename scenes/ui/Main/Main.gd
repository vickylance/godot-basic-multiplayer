extends Control


func _on_Send_pressed():
	Network.call_peer("Main", "set_text", $TextEdit.text)

func _on_Create_pressed():
	Network.create_server()

func _on_Join_pressed():
	Network.join_server()

func run_server_func(function, data: String):
	if function == "set_text":
		set_text(data)

func set_text(data: String):
	$TextEdit.text = data
