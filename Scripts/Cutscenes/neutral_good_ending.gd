extends Control

@export var status : PackedScene
const GOOD_ENDING_V_1_1 = preload("res://Assets/Audio/Music/Good Ending V1.1.wav")
const NEUTRAL_ENDING_V_1_1 = preload("res://Assets/Audio/Music/Neutral Ending V1.1.wav")

func _ready():
	var song = NEUTRAL_ENDING_V_1_1 if name.contains("Neutral") else GOOD_ENDING_V_1_1

	AudioManager.play_music(song, 0)

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
			get_tree().change_scene_to_packed(status)
