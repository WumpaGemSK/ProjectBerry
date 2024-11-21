extends Node

var selected_code: String

func _ready():
	selected_code = Constants.CODES.pick_random()
	EventBus.try_code.connect(on_code_try)
	
func on_code_try(code: String):
	if code == selected_code:
		EventBus.code_correct.emit()
	else:
		EventBus.code_incorrect.emit()
