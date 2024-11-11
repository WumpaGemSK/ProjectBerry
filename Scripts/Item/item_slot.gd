extends Item
class_name ItemSlot

@onready var icon = %Icon
@onready var count = %Count
@onready var count_block = %Count_Block

var quantity :int = 0:
	set(value):
		quantity = value
		count.text = "%d" % quantity
		count_block.visible = quantity > 1
# Called when the node enters the scene tree for the first time.
func _ready():
	icon.texture = texture_icon
	count_block.visible = quantity > 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
