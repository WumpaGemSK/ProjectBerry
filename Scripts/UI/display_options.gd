extends Control

@onready var value_label = %Value

## The arrays of items for the scale factor
## Populates the item list
@export var items : Array[float]

var index = 0
## Populate the list with the possible values
func _ready():
	#TODO: Find a way to preselect the option
	update_label(items[index])

## Emit the signal to change the viewport size with the factor as a parameter
func _on_item_list_item_selected(index):
	Settings._viewport_change_size.emit(items[index])

func _on_left_pressed():
	index = clamp(index-1, 0, items.size()-1)
	var factor = items[index]
	update_label(factor)
	Settings._viewport_change_size.emit(factor)

func _on_right_pressed():
	index = clamp(index+1, 0, items.size()-1)
	var factor = items[index]
	update_label(factor)
	Settings._viewport_change_size.emit(factor)

func update_label(number: float):
	value_label.text = "x%.01f" % number
