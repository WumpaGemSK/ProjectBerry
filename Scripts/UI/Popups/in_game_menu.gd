extends PopupPanel

@onready var display_options_popup = $DisplayOptionsPopup
@onready var audio_settings_popup = $AudioSettingsPopup

var sub_menu_open : bool = false

func _ready():
	display_options_popup.popup_panel.popup_hide.connect(hide_display_popup)
	audio_settings_popup.popup_panel.popup_hide.connect(hide_audio_popup)

	
func _on_close():
	display_options_popup.hide_popup()
	audio_settings_popup.hide_popup()
	audio_settings_popup.visible = false
	display_options_popup.visible = false
	sub_menu_open = false

func _process(_delta):
	if Input.is_action_pressed("options") and !sub_menu_open:
		if !self.visible:
			popup_centered(size)

func _on_resume_pressed():
	hide()

func _on_display_pressed():
	sub_menu_open = true
	display_options_popup.visible = true
	display_options_popup.popup()	


func _on_audio_pressed():
	sub_menu_open = true
	audio_settings_popup.visible = true
	audio_settings_popup.popup()

func hide_audio_popup():
	audio_settings_popup.visible = false

func hide_display_popup():
	display_options_popup.visible = false


func _on_close_requested():
	hide()


func _on_return_pressed():
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/TitleScreen.tscn")
