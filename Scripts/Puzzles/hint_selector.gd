extends Node2D

@export var pickable_item: PickableItem
@export var code: String

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Game.selected_code == code:
		pickable_item.process_mode = Node.PROCESS_MODE_DISABLED
		pickable_item.visible = false
