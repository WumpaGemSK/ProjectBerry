extends Control
class_name WeaponSlot

@onready var input_prompt = %InputPrompt
@onready var weapon_texture = %WeaponTexture

func set_texture(texture : Texture2D):
	weapon_texture.texture = texture

func set_input_prompt(texture : Texture2D, side_left : bool = true):
	input_prompt.texture = texture
	input_prompt.size_flags_horizontal = SIZE_SHRINK_END if side_left else SIZE_SHRINK_BEGIN
	input_prompt.visible = true
