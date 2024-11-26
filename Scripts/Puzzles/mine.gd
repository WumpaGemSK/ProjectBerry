extends Node2D

## Number of times the player can step on it before exploding
@export var steps: int = 1
@onready var sprite_2d = $Sprite2D

## When the mine reaches 0 steps_left
signal deactivated

var steps_left: int

func _ready():
	on_reload()
	EventBus.reload_scene.connect(on_reload)

func _on_area_2d_entered(area: Area2D):
	var body = area.get_parent()
	if body is Player:
		if steps_left > 0:
			steps_left -= 1
			if steps_left == 0:
				update_sprite()
				deactivated.emit()
		else:
			body.take_damage(1)
			SceneSwitcher.reload_scene()

func on_reload():
	steps_left = steps
	update_sprite()

func update_sprite():
	sprite_2d.region_rect = Rect2((1-steps_left)*24, 0, 24, 24)
