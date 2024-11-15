extends Control

@onready var weapon_slot = $MarginContainer/WeaponSlot

## Texture to show as the imput prompt
@export var input_prompt : Texture2D

func _ready():
	EventBus.item_used.connect(on_melee_weapon_equipped)
	
## Callback to show the cricket bat texture and the input prompt
func on_melee_weapon_equipped(item : Item):
	if item.type != Item.Item_type.CRICKET_BAT:
		return
	weapon_slot.set_texture(item.texture_icon)
	weapon_slot.set_input_prompt(input_prompt)
	show()
