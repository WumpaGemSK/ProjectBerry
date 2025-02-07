extends State

@export var hurting_duration : float = 0.5

var enemy : Enemy = null
var target_pos : Vector2

# Rethink the state machine. It may not need to have a physics process and only have a func to return the new path/target.
func enter():
	enemy = get_parent()
	var tween = create_tween()
	tween.tween_interval(hurting_duration)
	tween.tween_callback(func(): state_change.emit(Enemy.States.INVESTIGATING))
	target_pos = enemy.player.global_position
	return

func process(_delta: float):
	var animation = "damaged_"
	match enemy.facing_direction:
		Enemy.facing.UP:
			animation += "up"
		Enemy.facing.DOWN:
			animation += "down"
		Enemy.facing.LEFT:
			animation += "side"
			enemy.animated_sprite.flip_h = true
		Enemy.facing.RIGHT:
			enemy.animated_sprite.flip_h = false
			animation += "side"
	enemy.animated_sprite.play(animation)

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
