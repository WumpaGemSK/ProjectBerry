extends Control

@export var title_scn: PackedScene
@export var restart_scn : PackedScene

const BAD_ENDING_V_1_1 = preload("res://Assets/Audio/SFX/SFX_UI_NUCLEAREXPLOSION.wav")

func _ready():
	AudioManager.play_music(BAD_ENDING_V_1_1, 0)
	
func _on_restart_pressed():
	pass
	# This causes problem when reloading. Disabled until is fixed
	#get_tree().change_scene_to_packed(restart_scn)


func _on_title_screen_pressed():
	EventBus.reset.emit()
	get_tree().change_scene_to_packed(title_scn)
