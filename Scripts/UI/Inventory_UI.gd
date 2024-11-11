extends Control

@export var player : Player
@export var item_slot : PackedScene
@onready var grid_container : GridContainer = %InventoryGrid

var inventory : Array[ItemSlot] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.pick_item.connect(on_item_pickup)
	EventBus.show_inventory.connect(func(): visible = true)
	hide()
	inventory_updated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		visible = !visible
		grid_container.get_child(0).grab_focus()

func on_item_pickup(item: Item):
	for child in grid_container.get_children():
		var i = child as ItemSlot
		if i.is_equal(item):
			i.quantity += 1
			return
	var slot : ItemSlot = item_slot.instantiate()
	slot.name = item.item_name
	grid_container.add_child(slot)
	slot.quantity = 1
	slot.item_name = item.item_name
	slot.effect = item.effect
	slot.type = item.type
	slot.icon.texture = item.texture_icon
	inventory.append(slot)
	inventory_updated()

func inventory_updated():
	for child in grid_container.get_children():
		pass#child.queue_free()
	for item in inventory:
		grid_container.add_child(item)
	while grid_container.get_child_count() < 16:
		var slot = item_slot.instantiate()
		grid_container.add_child(slot)
		
