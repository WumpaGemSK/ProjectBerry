extends Control

@onready var weapon_slot = $MarginContainer/VBoxContainer/WeaponSlot
@onready var ammo_label = %AmmoLabel

@export var player : Player
@export var input_prompt : Texture2D

var current_ammo : int
var current_max_ammo : int

func _ready():
	current_ammo = player.pistol_ammo
	current_max_ammo = player.max_pistol_ammo
	player.pistol_ammo_update.connect(on_pistol_ammo_update)
	player.pistol_ammo_upgrade.connect(on_pistol_ammo_upgrade)
	player.equipped_weapon.connect(on_ranged_weapon_equipped)
	update_ammo_label()
	
func on_pistol_ammo_update(amount : int):
	current_ammo = amount
	update_ammo_label()
	
func on_pistol_ammo_upgrade(amount : int):
	current_max_ammo = amount
	update_ammo_label()

func update_ammo_label():
	ammo_label.text = "%d/%d" % [current_ammo, current_max_ammo]

func on_ranged_weapon_equipped(item : Item):
	if item.type != Item.Item_type.PISTOL:
		return
	weapon_slot.set_texture(item.texture_icon)
	weapon_slot.set_input_prompt(input_prompt, false)
