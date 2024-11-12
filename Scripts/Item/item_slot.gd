extends Item
class_name ItemSlot

@onready var icon : TextureRect = %Icon
@onready var count = %Count
@onready var count_block = %Count_Block
@onready var button = $Button

# Called when the node enters the scene tree for the first time.
func _ready():
	icon.texture = texture_icon
	count_block.visible = quantity > 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_item(item: Item):
	icon.texture = item.texture_icon
	quantity = item.quantity
	item_name = item.item_name
	effect = item.effect
	type = item.type
	update_count_label()

func set_empty():
	quantity = 0
	icon.texture = null
	type = Item.Item_type.NONE

func grab_focus():
	button.grab_focus()

func update_count_label():
	count.text = "%d" % quantity
	count_block.visible = quantity > 1
