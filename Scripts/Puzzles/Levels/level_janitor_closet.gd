extends Node2D

@onready var pickable_item = $Pickable_Item

# Called when the node enters the scene tree for the first time.
func _ready():
	if Game.selected_code == "BIVOU":
		pickable_item.visible = true
	else:
		pickable_item.visible = false
