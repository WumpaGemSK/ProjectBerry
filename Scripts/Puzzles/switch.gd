extends Node2D
class_name Switch

signal toggled(state: bool)

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var active: bool

func _ready():
	sprite_2d.region_rect.position = Vector2(0, 0) if not active else Vector2(24, 0)

## Toggle the state of the switch and return the current state
func toggle() -> bool:
	active = !active
	sprite_2d.region_rect.position.x += 24 if active else -24
	return active
