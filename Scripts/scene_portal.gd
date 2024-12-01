extends Node2D
class_name ScenePortal

#region Export variables
## Scene to switch to
@export var scn: PackedScene
## If true it will switch to the previous scene. Use it if you want to go back from a room
@export var to_previous: bool = false
## The direction of the door
@export var direction: Direction = Direction.UP
## The tier of the door. Between 0 and 3
@export_range(0, 3) var door_tier: int = 0
@export var opened: bool = false
#endregion
@onready var sprite_2d = $Sprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

## The position of the first door
var base: int = 0
var sprites_per_row: int = 2
var tile_width: int = 24
var tile_height: int = 24

enum Direction {
	UP,
	DOWN,
	RIGHT,
	LEFT
}

func _ready():
	update_sprite()

func _switch_scene(body: Node2D):
	if opened and body is Player:
		if to_previous:
			SceneSwitcher.to_previous()
		else:
			SceneSwitcher.change_scene(scn, self)

func _check_keys(body: Node2D):
	if body is Player:
		var highest_key_tier = body.find_child("Inventory").get_key_tier()
		open_door(highest_key_tier)

func update_sprite():
	var element = base + direction*2 + int(opened)
	sprite_2d.region_rect = Rect2((element%sprites_per_row)*tile_width, (element/sprites_per_row)*tile_height, tile_width,tile_height)

func open_door(tier: int):
	if tier >= door_tier:
		audio_stream_player_2d.play()
		opened = true
		update_sprite()
