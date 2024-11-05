extends Control
## Slider with a range of 0 to 1
class_name OptionSlider

## Name to display on the label
@export var option_name : String
@onready var label = $HBoxContainer/Label
@onready var h_slider = $HBoxContainer/HSlider

signal _slider_changed(value: float)

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = option_name
	h_slider.value_changed.connect(_on_value_changed)
	

## Emits the value received from the _value_changed [HSlider] to be caught for
## whichever nodes has the need to
func _on_value_changed(value: float):
	_slider_changed.emit(value)
