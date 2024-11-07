extends Control

@onready var popup_panel = $PopupPanel


func popup():
	popup_panel.popup_centered(popup_panel.min_size)

func hide_popup():
	popup_panel.hide()
