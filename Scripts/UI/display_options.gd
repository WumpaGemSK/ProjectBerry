extends Node
@onready var item_list = $ItemList

## The arrays of items for the scale factor
## Populates the item list
@export var items : Array = ["0.8", "1.3"]

func _ready():
	for item in items:
		item_list.add_item(item)
	#item_list.select(int(get_window().content_scale_factor)-1)

## Update the scale factor for the window
func _on_item_list_item_selected(index):
	get_window().size = get_window().size * items[index].to_float()
