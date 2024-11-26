extends Node2D
class_name Switch

signal toggled(state: bool)

@export var active: bool
@export var neighbor1: Switch
@export var neighbor2: Switch

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_interact():
	toggle()
	neighbor1.toggle()
	neighbor2.toggle()

func toggle():
	active = !active
	toggled.emit(active)
