extends Control

@onready var rect = $BoxContainer/MarginContainer/ColorRect
const full_size : int = 16
const empty_size : int = 10


func set_full():
	rect.custom_minimum_size = Vector2(full_size, full_size)

func set_empty():
	rect.custom_minimum_size = Vector2(empty_size, empty_size)
