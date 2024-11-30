extends RigidBody2D

func _process(delta):
	for obj in get_colliding_bodies():
		if obj is Player:
			continue
		var dir = global_position - obj.global_position
		apply_central_impulse(dir * 10)
