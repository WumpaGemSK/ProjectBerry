extends "res://Scripts/Enemies/stationary.gd"

func on_hearing(body: Node2D, enemy: Enemy):
	super(body, enemy)
	
func on_view(_body: Node2D, _enemy: Enemy):
	return

func update(enemy: Enemy, delta: float):
	if enemy.navigation_agent_2d.is_navigation_finished():
		AudioManager.play_effect_at(SoundEffect.SoundType.ENEMY_SLEEPING, enemy.global_position)
		enemy.facing_direction = enemy.original_facing_dir
	else:
		AudioManager.play_effect_at(SoundEffect.SoundType.ENEMY_RUN, enemy.global_position)
	var dir = enemy.facing_direction
	var animation = "sleeping_" if enemy.navigation_agent_2d.is_navigation_finished() else "walk_"
	match dir:
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
