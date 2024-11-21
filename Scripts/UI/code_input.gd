extends Control
class_name CodeInput

@onready var code = %Code

var letter : String:
	get():
		return String.chr(code_point)
var code_point: int

func _ready():
	# Defaults to A
	code_point = String("A").to_ascii_buffer()[0]
	update_label()

func _on_up_pressed():
	code_point += 1
	if code_point > "Z".to_ascii_buffer()[0]:
		code_point = "A".to_ascii_buffer()[0]
	update_label()

func _on_down_pressed():
	code_point -= 1
	if code_point < "A".to_ascii_buffer()[0]:
		code_point = "Z".to_ascii_buffer()[0]
	update_label()
	
func update_label():
	code.text = letter
