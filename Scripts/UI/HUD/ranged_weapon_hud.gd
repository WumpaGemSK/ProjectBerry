extends Control

@onready var weapon_slot = $MarginContainer/VBoxContainer/WeaponSlot
@onready var ammo_label = %AmmoLabel

## Texture to show as the imput prompt
@export var input_prompt : Texture2D

var current_ammo : int = 0
var current_max_ammo : int = 0

func _ready():
	EventBus.item_used.connect(on_ranged_weapon_equipped)
	EventBus.item_used.connect(on_pistol_ammo_update)
	EventBus.item_used.connect(on_pistol_ammo_upgrade)
	update_ammo_label()
	
func on_pistol_ammo_update(item: Item):
	if item.type == Item.Item_type.PISTOL_AMMO:
		current_ammo += item.effect
		update_ammo_label()
	
func on_pistol_ammo_upgrade(item: Item):
	if item.type == Item.Item_type.MAX_PISTOL_AMMO_UPGRADE:
		current_max_ammo = item.effect
		update_ammo_label()

func update_ammo_label():
	ammo_label.text = "%d/%d" % [current_ammo, current_max_ammo]

## Callback to show the pistol texture and the input prompt
func on_ranged_weapon_equipped(item : Item):
	if item.type != Item.Item_type.PISTOL:
		return
	weapon_slot.set_texture(item.texture_icon)
	weapon_slot.set_input_prompt(input_prompt, false)
	show()
