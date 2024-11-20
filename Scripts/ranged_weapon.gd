extends Weapon

## Amount of ammo available
@export var ammo: int
## Max amount of ammo
@export var max_ammo: int

func _ready():
	super()
	EventBus.pistol_ammo_update.emit(ammo)
	EventBus.pistol_ammo_upgrade.emit(max_ammo)

func attack(from: Vector2, dest: Vector2):
	if cooldown_timer.is_stopped() and ammo > 0:
		ammo -= 1
		cooldown_timer.start(cooldown)
		if is_player:
			EventBus.pistol_ammo_update.emit(ammo)
		var r = raycast_to_damageable(from, dest)
		if r != null and r.is_in_group("Damageable"):
			hit.emit()
			r.take_damage(damage)

func reload(amount: int) -> bool:
	if ammo < max_ammo:
		ammo = clampi(ammo + amount, 0, max_ammo)
		EventBus.pistol_ammo_update.emit(ammo)
		return true
	return false

func upgrade(item: Item):
	match item.type:
		Item.Item_type.PISTOL_DAMAGE_UPGRADE:
			damage += item.effect
			EventBus.item_used.emit(item)
		Item.Item_type.PISTOL_FIRE_RATE_UPGRADE:
			# TODO: Update to when fire rate is implemented
			EventBus.item_used.emit(item)
			pass
		Item.Item_type.MAX_PISTOL_AMMO_UPGRADE:
			max_ammo += item.effect
			EventBus.pistol_ammo_upgrade.emit(max_ammo)
			EventBus.item_used.emit(item)
