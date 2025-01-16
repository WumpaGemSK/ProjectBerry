extends "res://Scripts/Enemies/stationary.gd"

var original_position: Vector2

func enter():
	super()
	AudioManager.play_effect_at(SoundEffect.SoundType.ENEMY_SLEEPING, enemy.global_position)

func on_hearing(body: Node2D):
	super(body)
	
func on_view(_body: Node2D):
	return

func process(delta: float):
	var animation = "sleeping_" if navigation_agent_2d.is_navigation_finished() else "walk_"
	match enemy.facing_direction:
		Enemy.facing.LEFT:
			animation += "side"
			enemy.animated_sprite.flip_h = true
		Enemy.facing.RIGHT:
			enemy.animated_sprite.flip_h = false
			animation += "side"
		Enemy.facing.DOWN:
			animation += "down"
		Enemy.facing.UP:
			animation += "up"
	enemy.animated_sprite.play(animation)

func velocity_almost_zero(vec: Vector2):
	return is_zero_approx(vec.x) and is_zero_approx(vec.y)
