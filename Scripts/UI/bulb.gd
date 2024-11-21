extends Control

@export var normal_state_texture: Texture2D
@export var active_state_texture: Texture2D
@export var icon_texture: Texture2D
@onready var light = %Light
@onready var icon = %Icon

# Called when the node enters the scene tree for the first time.
func _ready():
	light.texture = normal_state_texture
	icon.texture = icon_texture

func activate():
	light.texture = active_state_texture
	
func deactivate():
	light.texture = normal_state_texture
