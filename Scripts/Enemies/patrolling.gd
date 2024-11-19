extends State

# Called when the node enters the scene tree for the first time.
func update(enemy: Enemy, delta: float):
	enemy.path_follow.progress += delta*enemy.movement_speed
	var new_pos = enemy.path_follow.global_position
	enemy.set_target_position(new_pos)
