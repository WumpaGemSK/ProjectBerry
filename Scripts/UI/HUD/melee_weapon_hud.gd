extends Control

@onready var weapon_slot = $MarginContainer/WeaponSlot
const CRICKET_BAT_BARBED_SLOT_ICON = preload("res://Assets/Textures/UI Screens/MainGameplayUI/ItemSlots/cricket_bat_barbed_slot_icon.png")
const CRICKET_BAT_SLOT_ICON = preload("res://Assets/Textures/UI Screens/MainGameplayUI/ItemSlots/cricket_bat_slot_icon.png")

func _ready():
	EventBus.item_used.connect(on_melee_weapon_equipped)
	
## Callback to show the cricket bat texture and the input prompt
func on_melee_weapon_equipped(item : Item):
	match item.type:
		Item.Item_type.CRICKET_BAT:
			weapon_slot.set_texture(CRICKET_BAT_SLOT_ICON)
		Item.Item_type.BARBED_WIRE_UPGRADE:
			weapon_slot.set_texture(CRICKET_BAT_BARBED_SLOT_ICON)
		_: return
	show()
