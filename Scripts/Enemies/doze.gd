extends "res://Scripts/Enemies/stationary.gd"

var is_stopped = true

func enter():
	super()

func on_hearing(body: Node2D):
	super(body)
	
func on_view(_body: Node2D):
	if is_stopped:
		return
	super(_body)

func process(delta: float):
	var vel = enemy.velocity
	is_stopped = velocity_almost_zero(vel)
	var animation = "sleeping_" if is_stopped else "walk_"
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
	
	var dist = enemy.global_position.distance_to(resting_pos)
	print(enemy.global_position)
	if is_stopped:
		AudioManager.play_effect_at(SoundEffect.SoundType.ENEMY_SLEEPING, enemy.global_position)

func velocity_almost_zero(vec: Vector2):
	return is_zero_approx(vec.x) and is_zero_approx(vec.y)
