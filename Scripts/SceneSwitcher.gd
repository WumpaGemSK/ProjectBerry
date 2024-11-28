extends Node

var prev_scene: Array[Node] = []

var prev_position: Array[Vector2] = []
var player: Player = null
var offset_distance: float = 30

var scenes: Dictionary = {}

func change_scene(scene: PackedScene, trigger: ScenePortal):
	if not player:
		player = get_tree().get_nodes_in_group("Player")[0]
	if not scenes.has(scene.resource_name):
		scenes.get_or_add(scene.resource_path, scene.instantiate())
	var new_scene = scenes.get(scene.resource_path)
	var spawn_point: Marker2D = new_scene.find_child("SpawnPoint")
	if spawn_point == null:
		print("No SpawnPoint found in the new scene %s" % scene.resource_name)
		return
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	prev_scene.push_back(get_current_scene())
	get_scene_holder().call_deferred("remove_child", get_current_scene())
	# Offset player from the collider to prevent instantly switching the scene
	var offset: Vector2 = direction_to_push(trigger.direction)*offset_distance
	var prev_pos = trigger.global_position + offset
	prev_position.push_back(prev_pos)
	get_scene_holder().call_deferred("add_child",new_scene)
	player.set_deferred("global_position", spawn_point.global_position)
	prev_position.push_back(spawn_point.global_position)
	
func to_previous():
	if prev_scene.is_empty():
		print("No scene to return to")
		return
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_scene_holder().call_deferred("remove_child", get_current_scene())
	get_scene_holder().call_deferred("add_child", prev_scene.pop_back())
	prev_position.pop_back()
	player.set_deferred("global_position", prev_position.pop_back())

func get_current_scene() -> Node:
	var holder = get_scene_holder()
	var current = holder.get_child(0)
	return current

func get_scene_holder() -> Node:
	return get_tree().root.get_child(-1).get_child(0)

func reload_scene():
	if not prev_position.is_empty():
		player.global_position = prev_position.back()
	EventBus.reload_scene.emit()

func direction_to_push(dir: ScenePortal.Direction) -> Vector2:
	match dir:
		ScenePortal.Direction.UP:
			return Vector2.DOWN
		ScenePortal.Direction.DOWN:
			return Vector2.UP
		ScenePortal.Direction.LEFT:
			return Vector2.RIGHT
		ScenePortal.Direction.RIGHT:
			return Vector2.LEFT
	return Vector2.ZERO
