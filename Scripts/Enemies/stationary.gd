extends State


# Called when the node enters the scene tree for the first time.
func enter(enemy: Enemy):
	enemy.set_target_position(enemy.resting_position)

func update(enemy: Enemy, delta: float):
	enemy.facing_direction = enemy.original_facing_dir
