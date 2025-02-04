extends Node

@onready var pickable_item : PickableItem = preload("res://Scenes/Pickable_Item.tscn").instantiate()

@export var drops : Array[ItemDrop]

func spawn_item(roll: float, position: Vector2):
	get_tree().root.add_child(pickable_item)
	var item = null
	for drop in drops:
		if drop.probability >= roll:
			item = drop.item
	pickable_item.global_position = position
	pickable_item.set_item(item)
