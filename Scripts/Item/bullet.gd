extends Node2D
class_name Bullet

var dir: Vector2
var speed: float = 300
var damage = 0

func _process(delta):
	global_position += dir*delta*speed

func _on_timer_timeout():
	queue_free()

func _on_area_2d_area_entered(area):
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		hitbox.take_damage(damage, dir)
		queue_free()
		
func set_col_mask(col: int):
	$Area2D.collision_mask |= Utils.layer_to_mask(col)
