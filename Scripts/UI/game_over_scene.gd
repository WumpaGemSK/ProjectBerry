extends Control

@export var title_scn: PackedScene
@export var restart_scn : PackedScene

func _on_restart_pressed():
	pass
	# This causes problem when reloading. Disabled until is fixed
	#get_tree().change_scene_to_packed(restart_scn)


func _on_title_screen_pressed():
	get_tree().change_scene_to_packed(title_scn)
