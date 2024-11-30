extends Control

#@onready var rect = $BoxContainer/MarginContainer/ColorRect
#const full_size : int = 16
#const empty_size : int = 10

@onready var full_unit_texture: TextureRect = $BoxContainer/MarginContainer/FullUnitTexture
@onready var empty_unit_texture: TextureRect = $BoxContainer/MarginContainer/EmptyUnitTexture

func set_full():
	
	#rect.custom_minimum_size = Vector2(full_size, full_size)
	full_unit_texture.show()
	empty_unit_texture.hide()

func set_empty():
	
	#rect.custom_minimum_size = Vector2(empty_size, empty_size)
	full_unit_texture.hide()
	empty_unit_texture.show()
