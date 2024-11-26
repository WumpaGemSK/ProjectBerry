extends Node2D
class_name Switch

## Sends the state of the switch after the toggle
signal toggled(state: Array[bool])

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var active: bool
@export var neighbor1: Switch
@export var neighbor2: Switch

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.region_rect.position = Vector2(0, 0) if not active else Vector2(24, 0)

## Toggle the neighbors and itself, collect the new states and send the signal with the states.
## The interacted Switch is the responsible of sending the signal
func _on_interactable_interact():
	var states: Array[bool] = []
	states.append(toggle())
	states.append(neighbor1.toggle())
	states.append(neighbor2.toggle())
	toggled.emit(states)

## Toggle the state of the switch and return the current state
func toggle() -> bool:
	active = !active
	sprite_2d.region_rect.position.x += 24 if active else -24
	return active
