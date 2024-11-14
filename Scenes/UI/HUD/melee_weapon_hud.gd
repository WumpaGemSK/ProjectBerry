extends Control

@export var player : Player
@onready var weapon_slot = $MarginContainer/WeaponSlot
@export var input_prompt : Texture2D

func _ready():
	player.equipped_weapon.connect(on_melee_weapon_equipped)
	
func on_melee_weapon_equipped(item : Item):
	if item.type != Item.Item_type.CRICKET_BAT:
		return
	weapon_slot.set_texture(item.texture_icon)
	weapon_slot.set_input_prompt(input_prompt)
