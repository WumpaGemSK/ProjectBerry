extends Node
@onready var item_list = $ItemList

## The arrays of items for the scale factor
## Populates the item list
@export var items : Array[float]

func _ready():
	for item in items:
		item_list.add_item("%.02f" % item)

## Multiply the window resolution by the scale factor
func _on_item_list_item_selected(index):
	Settings._viewport_change_size.emit(items[index])
