extends Control

@export var status : PackedScene
const BEST_ENDING_V_1_1 = preload("res://Assets/Audio/Music/Best Ending V1.1.wav")

func _ready():
	AudioManager.play_music(BEST_ENDING_V_1_1, 0)
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		
		if get_node("Page1").visible:
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			get_node("Page1").hide()
			get_node("Page2").show()
			
		if get_node("Page2").visible:
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			get_node("Page2").hide()
			get_node("Page3").show()
			
		if get_node("Page3").visible:
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			get_node("Page3").hide()
			get_node("Page4").show()
			
		if get_node("Page4").visible:
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			get_node("Page4").hide()
			get_node("Page5").show()
			
		elif get_node("Page5").visible:
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(status)
