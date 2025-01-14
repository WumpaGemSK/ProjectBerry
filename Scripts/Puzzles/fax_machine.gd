extends Node2D

var code: String

var code_item: PackedScene
@onready var animated_sprite_2d = $AnimatedSprite2D

@export var room: Game.Room
var pickable_item: PickableItem = preload("res://Scenes/Pickable_Item.tscn").instantiate()

# Check if the room has a code item assigned at the start
func _ready():
	if Game.get_fax_item(room) == null:
		print("No code item for room %s" % Game.Room.keys()[room])
		return


func print_code():
	animated_sprite_2d.play("default")
	AudioManager.play_effect_at(SoundEffect.SoundType.FAX_MACHINE, global_position)
	animated_sprite_2d.animation_finished.connect(generate_code_item)

func generate_code_item():
	animated_sprite_2d.frame = 0
	if pickable_item:
		var item = Game.get_fax_item(room)
		add_child(pickable_item)
		pickable_item.visible = false
		pickable_item.set_item(item)
		pickable_item.visible = true
