extends AnimatedSprite2D

@onready var mine_manager = $"../MineManager"

# Called when the node enters the scene tree for the first time.
func _ready():
	mine_manager.puzzle_complete.connect(on_puzzle_complete)

func on_puzzle_complete():
	play("drop_barrier")
	animation_finished.connect(on_animation_finished)

func on_animation_finished():
	var coll : CollisionPolygon2D = get_child(0).get_child(0)
	coll.disabled = true
	
