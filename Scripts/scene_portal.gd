extends Area2D

@export var scn: PackedScene

func _switch_scene(body: Node2D):
	if body is Player:
		SceneSwitcher.change_scene(scn)
