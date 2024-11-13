extends Control
class_name ItemSlot

@onready var icon : TextureRect = %Icon
@onready var count = %Count
@onready var count_block = %Count_Block
@onready var button = $Button

var item_res : Item = null

signal focused
signal pressed
# Called when the node enters the scene tree for the first time.
func _ready():
	#icon.texture = texture_icon
	set_empty()
	count_block.visible = item_res.quantity > 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_item(item: Item):
	item_res = item
	icon.texture = item_res.texture_icon
	update_count_label()

func set_empty():
	icon.texture = null
	item_res = Item.new()
	item_res.type = Item.Item_type.NONE
	item_res.quantity = 0

func set_focus():
	button.grab_focus()

func update_count_label():
	count.text = "%d" % item_res.quantity
	count_block.visible = item_res.quantity > 1


func _on_button_focus_entered():
	focused.emit(item_res)


func _on_button_pressed():
	pressed.emit(item_res)


func _on_button_mouse_entered():
	button.grab_focus()
