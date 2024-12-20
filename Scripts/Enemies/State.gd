extends Node2D
class_name State

@warning_ignore("unused_signal")
signal state_change(new_state: Enemy.States)

func enter(_enemy: Enemy):
	return

func update(_enemy: Enemy, _delta: float):
	return
	
func exit():
	return

func on_hearing(_body: Node2D, _enemy: Enemy):
	return

func on_hearing_exit(_body: Node2D, _enemy: Enemy):
	return

func on_view(_body: Node2D, _enemy: Enemy):
	return

func on_view_exit(_body: Node2D, _enemy: Enemy):
	return

func raycast_to_player(origin: Vector2, dest: Vector2, collision_mask, max_distance: float, exclude: Array[RID]):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(origin, dest, collision_mask, exclude)
	var result = space_state.intersect_ray(query)
	return result.collider is Player and result.position.distance_to(origin) < max_distance

func pause():
	return

func resume():
	return
