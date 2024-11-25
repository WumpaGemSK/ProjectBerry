extends Node2D

@export var steps: int = 1

var steps_left: int

func _ready():
	steps_left = steps
	EventBus.reload_scene.connect(func(): steps_left = steps)

# TODO: Fix ghost collision causing the mine to have one less step than what's expected
func _on_area_2d_body_entered(body):
	if body is Player:
		if steps_left > 0:
			steps_left -= 1
		else:
			body.take_damage(1)
			SceneSwitcher.reload_scene()
