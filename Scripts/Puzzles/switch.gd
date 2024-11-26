extends Node2D
class_name Switch

signal toggled(state: bool)

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var active: bool
@export var neighbor1: Switch
@export var neighbor2: Switch

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.region_rect.position = Vector2(0, 0) if not active else Vector2(24, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_interact():
	toggle()
	neighbor1.toggle()
	neighbor2.toggle()

func toggle():
	active = !active
	sprite_2d.region_rect.position.x += 24 if active else -24
	toggled.emit(active)
