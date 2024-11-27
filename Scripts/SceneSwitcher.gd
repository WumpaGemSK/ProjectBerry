extends Node

var prev_scene: Array[Node] = []

var prev_position: Array[Vector2] = []
var player: Player = null

func change_scene(scene: PackedScene, trigger: Node2D):
	if not player:
		player = get_tree().get_nodes_in_group("Player")[0]
	prev_position.push_back(player.global_position)
	var new_scene = scene.instantiate()
	var spawn_point: Marker2D = new_scene.find_child("SpawnPoint")
	if spawn_point == null:
		print("No SpawnPoint found in the new scene %s" % scene.resource_name)
		return
	prev_scene.push_back(get_current_scene())
	get_scene_holder().call_deferred("remove_child", get_current_scene())
	# Offset player from the collider to prevent instantly switching the scene
	prev_position.push_back(player.global_position + ((player.global_position - trigger.global_position)+Vector2(0,1)))
	get_scene_holder().call_deferred("add_child",new_scene)
	player.set_deferred("global_position", spawn_point.global_position)
	prev_position.push_back(spawn_point.global_position)
	
func to_previous():
	if prev_scene.is_empty():
		print("No scene to return to")
		return
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
