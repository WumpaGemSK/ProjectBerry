extends Node

@onready var pickable_item : PickableItem = preload("res://Scenes/Pickable_Item.tscn").instantiate()

@export var drops : Array[ItemDrop]

## Selects from the drops array the item with more rarity to spawn.
## @param roll: The probability to use from 0 to 1.
## @param position: The position to spawn the item. Global space.
func spawn_item(roll: float, position: Vector2):
	if len(drops) == 0:
		printerr("Tried to spawn loot without any drops in the list.")
		return
	get_tree().root.add_child(pickable_item)
	var item = null
	for drop in drops:
		if drop.probability >= roll:
			item = drop.item
	pickable_item.global_position = position
	pickable_item.set_item(item)
