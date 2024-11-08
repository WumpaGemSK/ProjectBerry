extends PanelContainer

@onready var resume = $VBoxContainer/Resume

@export var audio_settings_popup : PackedScene
@export var display_options_popup : PackedScene

func _process(_delta):
	if Input.is_action_pressed("options"):
		if !self.visible:
			show()
			resume.grab_focus()

func _on_resume_pressed():
	hide()

func _on_display_pressed():
	var display_scn = display_options_popup.instantiate()
	add_child(display_scn)
	display_scn.popup()


func _on_audio_pressed():
	var audio_scn = audio_settings_popup.instantiate()
	add_child(audio_scn)
	audio_scn.popup()


func _on_return_pressed():
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/TitleScreen.tscn")
