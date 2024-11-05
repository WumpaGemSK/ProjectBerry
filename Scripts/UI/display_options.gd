extends Node
@onready var item_list = $ItemList

func _ready():
	item_list.select(int(get_window().content_scale_factor)-1)

## Update the scale factor for the window
func _on_item_list_item_selected(index):
	get_window().content_scale_factor = float(index+1)
