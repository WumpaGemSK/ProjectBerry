extends Node2D

var code: String

var code_item: PackedScene
@onready var animated_sprite_2d = $AnimatedSprite2D

@export var room: Game.Room
var pickable_item: PickableItem = preload("res://Scenes/Pickable_Item.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	var item = Game.get_fax_item(room)
	if item == null:
		print("No code item for room %s" % Game.Room.keys()[room])
		return
	add_child(pickable_item)
	pickable_item.visible = false
	pickable_item.set_item(item)

func print_code():
	animated_sprite_2d.play("default")
	animated_sprite_2d.animation_finished.connect(generate_code_item)

func generate_code_item():
	if pickable_item:
		pickable_item.visible = true
