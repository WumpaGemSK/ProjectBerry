extends Node2D
class_name Flask

signal interact

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_interactable_interact():
	interact.emit()
