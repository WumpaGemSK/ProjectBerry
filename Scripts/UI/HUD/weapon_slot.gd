extends Control
class_name WeaponSlot

@onready var weapon_texture = %WeaponTexture

func set_texture(texture : Texture2D):
	weapon_texture.texture = texture
