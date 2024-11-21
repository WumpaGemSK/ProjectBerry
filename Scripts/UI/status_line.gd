extends Control
class_name StatusLine

@onready var field = $MarginContainer/Field
@onready var data = $MarginContainer/Data

func set_data(field_name: String, data_text: String):
	field.text = field_name
	data.text = data_text
