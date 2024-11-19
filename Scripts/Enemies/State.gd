extends Node
class_name State

signal state_change(new_state: Enemy.States)

func enter(enemy: Enemy):
	return

func update(enemy: Enemy, delta: float):
	return
	
func exit():
	return

func on_hearing(body: Node2D, enemy: Enemy):
	if body is Player:
		if not enemy.player.is_sneaking and enemy.state != enemy.chasing_state:
			state_change.emit(Enemy.States.INVESTIGATING)
	
func on_view(body: Node2D, enemy: Enemy):
	if body is Player:
		if enemy.raycast_to_player(INF):
			state_change.emit(Enemy.States.CHASING)
