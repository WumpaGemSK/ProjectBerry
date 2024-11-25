extends Node2D

## Number of times the player can step on it before exploding
@export var steps: int = 1
@onready var sprite_2d = $Sprite2D

## When the mine reaches 0 steps_left
signal deactivated

var steps_left: int

func _ready():
	steps_left = steps
	EventBus.reload_scene.connect(func(): steps_left = steps)

func _on_area_2d_entered(area: Area2D):
	var body = area.get_parent()
	if body is Player:
		if steps_left > 0:
			steps_left -= 1
			if steps_left == 0:
				sprite_2d.region_rect.position.x += 24
				deactivated.emit()
		else:
			body.take_damage(1)
			SceneSwitcher.reload_scene()
