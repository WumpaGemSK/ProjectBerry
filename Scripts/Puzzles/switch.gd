extends Node2D
class_name Switch

signal toggled(state: bool)

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var active: bool = false

func _ready():
	sprite_2d.region_rect.position = Vector2(0, 0) if not active else Vector2(24, 0)

## Toggle the state of the switch and return the current state
func toggle() -> bool:
	active = !active
	update_sprite()
	toggled.emit(active)
	return active

func reset():
	if active:
		active = false
		update_sprite()

func update_sprite():
	sprite_2d.region_rect.position.x += 24 if active else -24