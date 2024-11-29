extends Control
class_name CodeInput

@onready var texture_rect = $MarginContainer/VBoxContainer/TextureRect
const TERMINAL_LETTERS = preload("res://Assets/Textures/UI Screens/TerminalUI/terminal_letters.tres")
var letter : String:
	get():
		return String.chr(code_point)
var code_point: int

func _ready():
	# Defaults to A
	code_point = String("A").to_ascii_buffer()[0]
	texture_rect.texture = TERMINAL_LETTERS.duplicate(true)
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
	var width = 42
	var height = 44
	var offset = code_point - "A".to_ascii_buffer()[0]
	var x = (offset % 7) * width
	var y = floor(offset/7) * height
	texture_rect.texture.region = Rect2(x, y, width, height)
