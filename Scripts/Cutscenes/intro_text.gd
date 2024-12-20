extends Control

@export var how_to_play : PackedScene

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		
		if get_node("Page1").visible:
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			get_node("Page1").hide()
			get_node("Page2").show()
			
		elif get_node("Page2").visible:
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			get_node("Page2").hide()
			get_node("Page3").show()
			
		elif get_node("Page3").visible:
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(how_to_play)
