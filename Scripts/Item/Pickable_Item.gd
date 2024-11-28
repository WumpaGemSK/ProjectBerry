extends Node
class_name PickableItem

@onready var icon = %Icon

var player_in_range = false
@export var item : Resource

func _ready():
	if item:
		icon.texture = item.texture_icon

func _on_area_2d_body_entered(body):
	if body is Player:
		if not item.is_code():
			var item_copy = Item.copy(item)
			EventBus.pick_item.emit(item_copy)
			queue_free()

func set_item(new_item: Resource):
	item = new_item
	icon.texture = item.texture_icon

func _on_interactable_interact():
	var item_copy = Item.copy(item)
	EventBus.pick_item.emit(item_copy)
	queue_free()
