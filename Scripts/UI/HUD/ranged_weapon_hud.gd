extends Control

@onready var weapon_slot = $MarginContainer/VBoxContainer/WeaponSlot
@onready var ammo_label = %AmmoLabel
const PISTOL_SLOT_ICON = preload("res://Assets/Textures/UI Screens/MainGameplayUI/ItemSlots/pistol_slot_icon.png")
## Texture to show as the imput prompt
@export var input_prompt : Texture2D

var player: Player
var current_ammo : int = 0
var current_max_ammo : int = 0

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	current_ammo = player.pistol_ammo
	current_max_ammo = player.max_pistol_ammo
	EventBus.pistol_ammo_update.connect(on_pistol_ammo_update)
	EventBus.pistol_ammo_upgrade.connect(on_pistol_ammo_upgrade)
	EventBus.item_used.connect(on_ranged_weapon_equipped)
	update_ammo_label()
	
func on_pistol_ammo_update(amount: int):
	current_ammo = amount
	update_ammo_label()
	
func on_pistol_ammo_upgrade(amount: int):
	current_max_ammo = amount
	update_ammo_label()

func update_ammo_label():
	ammo_label.text = "%d/%d" % [current_ammo, current_max_ammo]

## Callback to show the pistol texture and the input prompt
func on_ranged_weapon_equipped(item : Item):
	if item.type != Item.Item_type.PISTOL:
		return
	weapon_slot.set_texture(PISTOL_SLOT_ICON)
	weapon_slot.set_input_prompt(input_prompt, false)
	show()
