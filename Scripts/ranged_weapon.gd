extends Weapon

@export var ammo: int
@export var max_ammo: int

func attack(from: Vector2, dest: Vector2):
	if cooldown_timer.is_stopped() and ammo > 0:
		ammo -= 1
		var r = raycast_to_damageable(from, dest)
		if r != null and r.is_in_group("Damageable"):
			attacking.emit()
			r.take_damage(damage)
		cooldown_timer.start(cooldown)

func reload(amount: int) -> bool:
	if ammo < max_ammo:
		ammo = clampi(ammo + amount, 0, max_ammo)
		return true
	return false
