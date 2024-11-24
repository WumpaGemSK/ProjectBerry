extends Area2D

## Scene to switch to
@export var scn: PackedScene

## If true it will switch to the previous scene. Use it if you want to go back from a room
@export var to_previous: bool = false

func _switch_scene(body: Node2D):
	if body is Player:
		if to_previous:
			SceneSwitcher.to_previous()
		else:
			SceneSwitcher.change_scene(scn, self)
