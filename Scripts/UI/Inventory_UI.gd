extends Control

@export var item_slot : PackedScene
@export var inventory: Node
@onready var grid_container : GridContainer = %InventoryGrid
@onready var item_detail = %ItemDetail

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.on_inventory_update.connect(inventory_updated)
	EventBus.show_inventory.connect(func(): visible = true)
	hide()
	inventory_updated({})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		visible = !visible
		if visible:
			EventBus.pause.emit()
			grid_container.get_child(0).set_focus()
		else:
			EventBus.resume.emit()

## Populates the inventory UI based on the contents of the inventory
func inventory_updated(inv : Dictionary):
	for child in grid_container.get_children():
		grid_container.remove_child(child)
		child.focused.disconnect(on_focused)
		child.pressed.disconnect(on_pressed)
		child.queue_free()
	
	for key in inv:
		if inv[key].quantity > 0:
			var new_slot : ItemSlot = item_slot.instantiate()
			grid_container.add_child(new_slot)
			new_slot.set_item(inv[key])
			new_slot.focused.connect(on_focused)
			new_slot.pressed.connect(on_pressed)
	
	while grid_container.get_child_count() < 16:
		var slot = item_slot.instantiate()
		grid_container.add_child(slot)
		slot.set_empty()
		slot.focused.connect(on_focused)
		slot.pressed.connect(on_pressed)
	# TODO: This makes the focus to shift to the first element when used
	grid_container.get_child(0).set_focus()
		
func on_focused(item: Item):
	item_detail.show_detail(item)

func on_pressed(item : Item):
	EventBus.use_item.emit(item)
