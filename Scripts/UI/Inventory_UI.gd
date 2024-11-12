extends Control

@export var player : Player
@export var item_slot : PackedScene
@onready var grid_container : GridContainer = %InventoryGrid
@onready var item_detail = %ItemDetail

var inventory : Array[Item] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.resize(16)
	EventBus.pick_item.connect(on_item_pickup)
	EventBus.show_inventory.connect(func(): visible = true)
	hide()
	inventory_updated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		visible = !visible
		if visible:
			grid_container.get_child(0).set_focus()

func on_item_pickup(item: Item):
	for i in range(inventory.size()):
		var it : Item = inventory[i]
		if it != null and it.type == item.type and it.effect == item.effect:
			it.quantity += 1
			inventory_updated()
			return
		elif it == null:
			inventory[i] = item
			inventory_updated()
			return

func inventory_updated():
	for child in grid_container.get_children():
		grid_container.remove_child(child)
		child.focused.disconnect(on_focused)
		child.pressed.disconnect(on_pressed)
		child.queue_free()
	for i in range(inventory.size()):
		if inventory[i] != null:
			var new_slot : ItemSlot = item_slot.instantiate()
			grid_container.add_child(new_slot)
			new_slot.set_item(inventory[i])
			new_slot.focused.connect(on_focused)
			new_slot.pressed.connect(on_pressed)
	while grid_container.get_child_count() < 16:
		var slot = item_slot.instantiate()
		grid_container.add_child(slot)
		slot.set_empty()
		slot.focused.connect(on_focused)
		slot.pressed.connect(on_pressed)
		
func on_focused(item: Item):
	item_detail.show_detail(item)

func on_pressed(item : Item):
	print("pressed")
	pass
