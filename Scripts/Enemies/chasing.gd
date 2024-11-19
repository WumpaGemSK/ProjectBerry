extends State


func update(enemy: Enemy, delta: float):
	enemy.set_target_position(enemy.player.global_position)
