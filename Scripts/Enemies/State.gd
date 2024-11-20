extends Node2D
class_name State

signal state_change(new_state: Enemy.States)

func enter(_enemy: Enemy):
	return

func update(_enemy: Enemy, _delta: float):
	return
	
func exit():
	return

func on_hearing(body: Node2D, _enemy: Enemy):
	return

func on_hearing_exit(body: Node2D, _enemy: Enemy):
	return

func on_view(body: Node2D, enemy: Enemy):
	return

func on_view_exit(body: Node2D, enemy: Enemy):
	return

func raycast_to_player(origin: Vector2, dest: Vector2, collision_mask, max_distance: float, exclude: Array[RID]):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(origin, dest, collision_mask, exclude)
	var result = space_state.intersect_ray(query)
	return result.collider is Player and result.position.distance_to(origin) < max_distance
