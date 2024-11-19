extends Node2D
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
		if not body.is_sneaking:
			state_change.emit(Enemy.States.INVESTIGATING)
	
func on_view(body: Node2D, enemy: Enemy):
	if body is Player:
		if raycast_to_player(enemy.global_position, body.global_position, enemy.collision_mask, INF, [self]):
			state_change.emit(Enemy.States.CHASING)

func raycast_to_player(origin: Vector2, dest: Vector2, collision_mask, max_distance: float, exclude: Array[RID]):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(origin, dest, collision_mask, exclude)
	var result = space_state.intersect_ray(query)
	return result.collider is Player and result.position.distance_to(dest) < max_distance
