extends Node
class_name PickableItem

@onready var pick_ui = %Pick_UI
@onready var icon = %Icon

var player_in_range = false
@export var item : Resource

func _ready():
	if item:
		icon.texture = item.texture_icon

func _process(_delta):
	if Input.is_action_pressed("interact") and player_in_range:
		var item_copy = Item.copy(item)
		EventBus.pick_item.emit(item_copy)
		queue_free()
	

func _on_area_2d_body_entered(body):
	if body is Player:
		var item_copy = Item.copy(item)
		EventBus.pick_item.emit(item_copy)
		queue_free()
		player_in_range = true
		pick_ui.visible = true


func _on_area_2d_body_exited(body):
	if body is Player:
		player_in_range = false
		pick_ui.visible = false

func set_item(new_item: Resource):
	item = new_item
	icon.texture = item.texture_icon
