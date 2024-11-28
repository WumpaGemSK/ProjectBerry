extends Control

@export var next_scene : PackedScene

func _ready() -> void:
	
	await get_tree().create_timer(2).timeout
	move_to_next_scene()

func move_to_next_scene():
		
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(next_scene)
