extends Control


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://Scenes/UI/TitleScreen.tscn"))
