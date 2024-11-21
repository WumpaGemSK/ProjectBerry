extends Control

@onready var code_list = %CodeList

func _ready():
	visible = false
	EventBus.open_terminal.connect(func(): visible = true)
	EventBus.close_terminal.connect(func(): visible = false)

func _on_send_code_pressed():
	var code: String = ""
	for i in code_list.get_child_count():
		var input: CodeInput = code_list.get_child(i)
		var letter = input.letter
		code += letter
	EventBus.try_code.emit(code)
