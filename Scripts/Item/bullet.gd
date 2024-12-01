extends Node2D
class_name Bullet

var dir: Vector2
var speed: float = 300

func _process(delta):
	global_position += dir*delta*speed

func _on_timer_timeout():
	queue_free()
