extends Node

signal on_inventory_update(inventory : Dictionary)

var inventory : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.pick_item.connect(on_item_pickup)
	EventBus.item_used.connect(on_item_used)

## Callback to handle an item pickup. If it's a weapon or upgrade it isn't store in the inventory
## and the upgrade is applied automatically
## If it's an item it's added into the inventory or the quantity is increased if already present
func on_item_pickup(item: Item):
	if item.is_weapon() or item.is_upgrade():
		EventBus.use_item.emit(item)
		return
	if item.is_key():
		if inventory.has(item.type) and item.effect > inventory[item.type].effect:
			inventory[item.type] = item
		else:
			inventory[item.type] = item
		on_inventory_update.emit(inventory)
		return # Early return to prevent increasing the quantity of keys
	if inventory.has(item.type):
		var existing_item : Item = inventory.get(item.type)
		existing_item.quantity += 1
	else:
		inventory.get_or_add(item.type, item)
	
	on_inventory_update.emit(inventory)

## Update the inventory after the item has been used
func on_item_used(item: Item):
	if inventory.has(item.type):
		var it : Item = inventory.get(item.type)
		it.quantity -= 1
		if it.quantity == 0:
			inventory.erase(item.type)
		on_inventory_update.emit(inventory)
