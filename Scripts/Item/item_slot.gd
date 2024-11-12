extends Control
class_name ItemSlot

@onready var icon : TextureRect = %Icon
@onready var count = %Count
@onready var count_block = %Count_Block
@onready var button = $Button

var item_res : Item = null
var quantity : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	#icon.texture = texture_icon
	count_block.visible = quantity > 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_item(item: Item):
	icon.texture = item.texture_icon
	quantity = item.quantity
	item_res = item
	update_count_label()

func set_empty():
	quantity = 0
	icon.texture = null
	item_res = Item.new()
	item_res.type = Item.Item_type.NONE

func set_focus():
	button.grab_focus()

func update_count_label():
	count.text = "%d" % quantity
	count_block.visible = quantity > 1
