extends Control

onready var IpAddress := $Panel/JoinRect/VBoxContainer/IpContainer/IpAddr as LineEdit

func _on_HostBtn_pressed():
	ConnectionManager.on_host_game()

func _on_JoinBtn_pressed():
	var ipAddress := IpAddress.text
	ConnectionManager.on_join_game(ipAddress)
