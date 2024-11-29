extends Control

@onready var code_list = %CodeList

func _ready():
	visible = false
	EventBus.open_terminal.connect(on_terminal_open)
	EventBus.close_terminal.connect(on_terminal_close)

func _input(event):
	if event.is_action_pressed("ui_back"):
		EventBus.close_terminal.emit()

func _on_send_code_pressed():
	var code: String = ""
	for i in code_list.get_child_count():
		var input: CodeInput = code_list.get_child(i)
		var letter = input.letter
		code += letter
	EventBus.try_code.emit(code)

func on_terminal_open():
	visible = true
	EventBus.pause.emit()

func on_terminal_close():
	visible = false
	EventBus.resume.emit()
