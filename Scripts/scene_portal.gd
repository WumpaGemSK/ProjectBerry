extends Area2D

#region Export variables
## Scene to switch to
@export var scn: PackedScene
## If true it will switch to the previous scene. Use it if you want to go back from a room
@export var to_previous: bool = false
## The direction of the door
@export var direction: Direction = Direction.UP
## The tier of the door. Between 1 and 3
@export_range(1, 3) var door_tier: int = 1
@export var opened: bool = false
#endregion
@onready var sprite_2d = $Sprite2D

## The position of the first door
var base: int = 12
var sprites_per_row: int = 5
var tile_width: int = 24
var tile_height: int = 24

enum Direction {
	UP,
	DOWN,
	RIGHT,
	LEFT
}

func _ready():
	var element = base + direction*2 + int(opened)
	print(element)
	sprite_2d.region_rect = Rect2((element%sprites_per_row)*tile_width, (element/sprites_per_row)*tile_height, tile_width,tile_height)

func _switch_scene(body: Node2D):
	if opened and body is Player:
		if to_previous:
			SceneSwitcher.to_previous()
		else:
			SceneSwitcher.change_scene(scn, self)
