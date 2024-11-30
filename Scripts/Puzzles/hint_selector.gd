extends Node2D

@export var pickable_item: PickableItem
@export var code: String

# Called when the node enters the scene tree for the first time.
func _ready():
	if Game.selected_code == code:
		pickable_item.visible = true
	else:
		pickable_item.visible = false
