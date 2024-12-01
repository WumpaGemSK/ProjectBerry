extends Node2D
class_name Bullet

var dir: Vector2
var speed: float = 300
var damage = 0

func _process(delta):
	global_position += dir*delta*speed

func _on_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Damageable"):
		body.take_damage(damage)
	queue_free()
