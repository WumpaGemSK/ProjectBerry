extends Node2D

@export var steps: int = 1

var steps_left: int

func _ready():
	steps_left = steps
	EventBus.reload_scene.connect(func(): steps_left = steps)

func _on_area_2d_entered(area: Area2D):
	var body = area.get_parent()
	if body is Player:
		if steps_left > 0:
			steps_left -= 1
		else:
			body.take_damage(1)
			SceneSwitcher.reload_scene()
