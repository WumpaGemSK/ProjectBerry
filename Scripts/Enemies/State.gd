extends Node2D
class_name State

signal state_change(new_state: Enemy.States)
signal move_to(new_pos: Vector2)

# Rethink the state machine. It may not need to have a physics process and only have a func to return the new path/target.
func enter():
	return

func process(_delta: float):
	return

func physics_process(delta):
	return

func get_move_path(curr: Vector2) -> PackedVector2Array:
	return []

func exit():
	return

func on_hearing(_body: Node2D):
	return

func on_hearing_exit(_body: Node2D):
	return

func on_view(_body: Node2D):
	return

func on_view_exit(_body: Node2D):
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
