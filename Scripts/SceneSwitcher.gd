extends Node

var prev_scene: Node = null

var prev_position: Vector2
var player: Player

func change_scene(scene: PackedScene):
	prev_scene = get_current_scene().duplicate()
	get_scene_holder().remove_child(get_current_scene())
	player = get_tree().get_nodes_in_group("Player")[0]
	prev_position = player.global_position
	var new_scene = scene.instantiate()
	get_scene_holder().add_child(new_scene)
	var spawn_point: Marker2D = new_scene.find_child("SpawnPoint")
	player.global_position = spawn_point.global_position
	
func to_previous():
	player = get_tree().get_nodes_in_group("Player")[0]
	get_tree().root.remove_child(get_tree().current_scene)
	get_tree().root.add_child(prev_scene)
	player.global_position = prev_position
	get_tree().root.add_child(prev_scene)
	prev_scene.add_child(player)

func get_current_scene() -> Node:
	var holder = get_scene_holder()
	var current = holder.get_child(0)
	return current

func get_scene_holder() -> Node:
	return get_tree().root.get_child(-1).get_child(0)
