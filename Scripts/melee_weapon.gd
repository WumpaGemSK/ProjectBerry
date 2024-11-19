extends Weapon

func attack(from: Vector2, dest: Vector2):
	if cooldown_timer.is_stopped():
		var r = raycast_to_damageable(from, dest)
		if r != null and r.is_in_group("Damageable"):
			attacking.emit()
			r.take_damage(damage)
		cooldown_timer.start(cooldown)
