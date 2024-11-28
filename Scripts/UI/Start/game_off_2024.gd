extends Control

@export var next_scene : PackedScene

func _ready() -> void:
	
	await get_tree().create_timer(3).timeout
	move_to_next_scene()

func move_to_next_scene():
	
	get_tree().change_scene_to_packed(next_scene)
