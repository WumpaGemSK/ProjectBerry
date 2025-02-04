extends Node

@onready var pickable_item : PickableItem = preload("res://Scenes/Pickable_Item.tscn").instantiate()

func spawn_item(item: Item, position: Vector2):
	get_tree().root.add_child(pickable_item)
	pickable_item.global_position = position
	pickable_item.set_item(item)
