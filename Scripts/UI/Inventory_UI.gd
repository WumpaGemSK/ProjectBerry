extends Node

@export var player : Player
@export var item_slot : PackedScene
@onready var grid_container = $PanelContainer/VBoxContainer/HBoxContainer/GridContainer

var inventory : Array[Item] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.pick_item.connect(on_item_pickup)
	#inventory_updated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_item_pickup(item: Item):
	for child in grid_container.get_children():
		var i = child as ItemSlot
		if i.is_equal(item):
			i.quantity += 1
			return
	var slot : ItemSlot = item_slot.instantiate()
	grid_container.add_child(slot)
	slot.quantity = 1
	slot.item_name = item.item_name
	slot.effect = item.effect
	slot.type = item.type
	slot.icon.texture = item.texture_icon
	#inventory_updated()

func inventory_updated():
	for child in grid_container.get_children():
		child.queue_free()
	for item in inventory:
		var slot : ItemSlot = item_slot.instantiate()
		slot.quantity = 1
		grid_container.add_child(slot)
	
	while grid_container.get_child_count() < 16:
		var slot = item_slot.instantiate()
		grid_container.add_child(slot)
		
