extends PanelContainer

@onready var resume = $VBoxContainer/Resume

@export var audio_settings_popup : PackedScene
@export var display_options_popup : PackedScene

## Listen for the "options" action and show the menu. Make the resume button
## grab the focus to be able to use keyboard/controller to navigate
func _process(_delta):
	# TODO: May be better to switch this logic to listen for the "pause" signal
	# and check for inputs somewhere else
	if Input.is_action_pressed("options"):
		if !self.visible:
			AudioManager.play_effect(SoundEffect.SoundType.UI_OPEN_MENU)
			show()
			resume.grab_focus()

## Hide the menu
func _on_resume_pressed():
	hide()
	EventBus.resume.emit()
	
## Instantiate the DisplayOptionsPopup scene, add it as child and call popup to
## make the popup visible, the popup behaviour is controlled by instantiated node
func _on_display_pressed():
	return
	var display_scn = display_options_popup.instantiate()
	add_child(display_scn)
	display_scn.popup()

## Instantiate the AudioSettingsPopup scene, add it as child and call popup to
## make the popup visible, the popup behaviour is controlled by instantiated node
func _on_audio_pressed():
	return
	var audio_scn = audio_settings_popup.instantiate()
	add_child(audio_scn)
	audio_scn.popup()

func _on_return_pressed():
	EventBus.reset.emit()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/TitleScreen.tscn")

func _on_restart_pressed():
	get_tree().call_deferred("reload_current_scene")

func _on_in_game_menu_visibility_changed():
	if visible:
		EventBus.pause.emit()
	else:
		EventBus.resume.emit()
