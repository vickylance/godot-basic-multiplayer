extends Control

onready var chatLog := get_node("VBoxContainer/RichTextLabel") as RichTextLabel
onready var roomName := get_node("VBoxContainer/HBoxContainer/Room") as Label
onready var inputField := get_node("VBoxContainer/HBoxContainer/ChatInput") as LineEdit

var group = [{
	"name": "Global",
	"color": "#ffffff"
}, {
	"name": "Team",
	"color": "#34c5f1",
}, {
	"name": "Match",
	"color": "#f1c234",
}]

var groupIndex := 0 setget setGroupIndex
var userName := "Vickylance"
var chatFocus := false setget setChatFocus

func setGroupIndex(newVal) -> void:
	groupIndex = newVal
	roomName.text = "[" + group[groupIndex].name + "]"
	roomName.set("custom_colors/font_color", Color(group[groupIndex].color))

func setChatFocus(newVal) -> void:
	chatFocus = newVal
	if chatFocus == true:
		inputField.grab_focus()
	else:
		inputField.release_focus()

func _ready() -> void:
	inputField.connect("text_entered", self, "chat_input")
	inputField.connect("focus_entered", self, "chat_entered")
	inputField.connect("focus_exited", self, "chat_left")
	change_group(0)

func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ENTER:
			self.chatFocus = not chatFocus
		elif event.scancode == KEY_ESCAPE:
			chatFocus = false
		elif event.shift and event.scancode == KEY_TAB:
			change_group(-1)
		elif event.scancode == KEY_TAB:
			change_group(1)

func change_group(value: int) -> void:
	if (groupIndex + value) > (group.size() - 1):
		self.groupIndex = 0
	elif (groupIndex + value) < 0:
		self.groupIndex = group.size() - 1
	else:
		self.groupIndex += value

func add_message(username: String, chatMessage: String, groupIndex := 0) -> void:
	chatLog.bbcode_text += "\n"
	chatLog.bbcode_text += "[color=" + group[groupIndex].color + "] "
	chatLog.bbcode_text += "[ " + group[groupIndex].name + " ] "
	chatLog.bbcode_text += username + ": "
	chatLog.bbcode_text += chatMessage
	chatLog.bbcode_text += "[/color]"

func chat_input(chatMessage: String) -> void:
	if chatMessage != '':
		inputField.text = ''
		add_message(userName, chatMessage, groupIndex)

func chat_entered() -> void:
	print("enter")
	chatFocus = true

func chat_left() -> void:
	print("exit")
	chatFocus = false

