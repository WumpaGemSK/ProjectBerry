extends Control
class_name StatusLine

@onready var field = %Field
@onready var filler = %Filler
@onready var data = %Data

func set_data(field_name: String, data_text: String):
	field.text = field_name
	data.text = data_text
	#call_deferred("set_filler")

func set_filler():
	var field_width = field.size.x
	var data_width = data.size.x
	var s = size.x
	var count: int = s - field_width - data_width
	filler.position.x += field_width
	filler.size.x -= field_width
	filler.text = "*   ".repeat(count/14)
