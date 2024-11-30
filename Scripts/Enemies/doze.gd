extends "res://Scripts/Enemies/stationary.gd"


func on_hearing(body: Node2D, enemy: Enemy):
	super(body, enemy)
	
func on_view(_body: Node2D, _enemy: Enemy):
	return

func update(enemy: Enemy, delta: float):
	var dir = enemy.facing_direction
	var animation = "sleeping_" if enemy.velocity == Vector2.ZERO else "walk_"
	match dir:
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
