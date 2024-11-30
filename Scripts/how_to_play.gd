extends Control

@export var game_scene : PackedScene

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(game_scene)
