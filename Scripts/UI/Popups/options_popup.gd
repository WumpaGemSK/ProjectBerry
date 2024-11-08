extends Control
class_name OptionsPopup

signal popup_hide

@onready var popup_panel:PopupPanel = $PopupPanel

## Connect to the popup_hide signal and make the popup appear centered in the screen
## This behaviour could be change
func popup():
	popup_panel.popup_hide.connect(emit_close)
	popup_panel.popup_centered(popup_panel.min_size)
	
func hide_popup():
	popup_panel.hide()

## Emit close signal just in case someone else care and delete node.
## This popup will be instantiated when needed
func emit_close():
	popup_hide.emit()
	queue_free()
