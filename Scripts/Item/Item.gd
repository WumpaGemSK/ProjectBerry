extends Node
class_name Item

## Types of item
enum Item_type {
	## Medical pack, effect tells how much health to recover
	MEDIPACK,
	## Pistol ammo pack, effect tells how many bullets to add
	PISTOL_AMMO,
	## Item is a serum
	SERUM,
	## Item is a chill pill
	CHILL_PILL,
	## Item is a key that can open doors, effect tells the tier
	KEY,
	## Item is a note, can be read in the inventory
	NOTE,
	# NOTE: Can't choose which type
	## Item is an upgrade
	UPGRADE
}

## The item name
@export var item_name : String
## The icon to display
@export var texture_icon : Texture2D
## Description of the item
@export var description : String
## The type of the item
@export var type : Item_type
## Effect meaning depends on the type
@export var effect : int = 0

func is_equal(item: Item) -> bool:
	return item.type == type and item.effect == effect and item.item_name == item_name

## Make a new copy of an item
static func copy(item: Item) -> Item:
	var res = Item.new()
	res.item_name = item.item_name
	res.texture_icon = item.texture_icon
	res.description = item.description
	res.type = item.type
	res.effect = item.effect
	return res
