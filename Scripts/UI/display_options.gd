extends Control
@onready var item_list = $HSplitContainer/ItemList

## The arrays of items for the scale factor
## Populates the item list
@export var items : Array[float]

## Populate the list with the possible values
func _ready():
	for item in items:
		item_list.add_item("%.02f" % item)
	item_list.grab_focus()

## Emit the signal to change the viewport size with the factor as a parameter
func _on_item_list_item_selected(index):
	Settings._viewport_change_size.emit(items[index])
