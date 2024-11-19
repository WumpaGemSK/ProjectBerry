extends State

## The speed in which the enemy will return to the resting position
@export var movement_speed: float

func enter(enemy: Enemy):
	enemy.set_target_position(enemy.resting_position)
	enemy.movement_speed = movement_speed
	enemy.prompt.texture = null

func update(enemy: Enemy, _delta: float):
	enemy.facing_direction = enemy.original_facing_dir
	
func on_hearing(body: Node2D, enemy: Enemy):
	super(body, enemy)
	
func on_view(body: Node2D, enemy: Enemy):
	super(body, enemy)
