extends Switch
class_name SwitchToggle

signal activated

func _on_interactable_interact():
	toggle()
	activated.emit()
