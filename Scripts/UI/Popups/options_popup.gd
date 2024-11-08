extends Control
class_name OptionsPopup

signal popup_hide

@onready var popup_panel:PopupPanel = $PopupPanel

func popup():
	popup_panel.popup_hide.connect(emit_close)
	popup_panel.popup_centered(popup_panel.min_size)
	

func hide_popup():
	popup_panel.hide()

func emit_close():
	popup_hide.emit()
	queue_free()
