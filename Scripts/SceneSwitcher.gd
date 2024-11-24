extends Node

var prev_scene: Node = null

var prev_position: Vector2
var player: Player

func change_scene(scene: PackedScene, trigger: Node2D):
	var new_scene = scene.instantiate()
	var spawn_point: Marker2D = new_scene.find_child("SpawnPoint")
	if spawn_point == null:
		print("No SpawnPoint found in the new scene %s" % scene.resource_name)
		return
	prev_scene = get_current_scene()
	get_scene_holder().call_deferred("remove_child", get_current_scene())
	player = get_tree().get_nodes_in_group("Player")[0]
	# Offset player from the collider to prevent instantly switching the scene
	prev_position = player.global_position + ((player.global_position - trigger.global_position)+Vector2(0,1))
	get_scene_holder().call_deferred("add_child",new_scene)
	player.set_deferred("global_position", spawn_point.global_position)
	
func to_previous():
	if prev_scene == null:
		print("No scene to return to")
		return
	get_scene_holder().call_deferred("remove_child", get_current_scene())
	get_scene_holder().call_deferred("add_child", prev_scene)
	player.set_deferred("global_position", prev_position)

func get_current_scene() -> Node:
	var holder = get_scene_holder()
	var current = holder.get_child(0)
	return current

func get_scene_holder() -> Node:
	return get_tree().root.get_child(-1).get_child(0)
