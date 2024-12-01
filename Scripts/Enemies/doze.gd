extends "res://Scripts/Enemies/stationary.gd"

@onready var sleeping: AudioStreamPlayer2D = $Sleeping
@onready var run: AudioStreamPlayer2D = $Run

func on_hearing(body: Node2D, enemy: Enemy):
	super(body, enemy)
	
func on_view(_body: Node2D, _enemy: Enemy):
	return

func update(enemy: Enemy, delta: float):
	#if enemy.navigation_agent_2d.is_navigation_finished():
		#if not sleeping.playing:
			#sleeping.play()
	#else:
		#if not run.playing:
			#run.play()
	var dir = enemy.facing_direction
	var animation = "sleeping_" if enemy.navigation_agent_2d.is_navigation_finished() else "walk_"
	match dir:
		Enemy.facing.LEFT:
			animation += "side"
			enemy.animated_sprite.flip_h = true
		Enemy.facing.RIGHT:
			enemy.animated_sprite.flip_h = false
			animation += "side"
		_:
			animation += "down"
	enemy.animated_sprite.play(animation)

func velocity_almost_zero(vec: Vector2):
	return is_zero_approx(vec.x) and is_zero_approx(vec.y)

func pause():
	run.stop()
	sleeping.stop()
