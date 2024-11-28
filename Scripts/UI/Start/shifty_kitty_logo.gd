extends Control

@export var next_scene : PackedScene

func move_to_next_scene():
	
	get_tree().change_scene_to_packed(next_scene)
