extends Weapon

## Amount of ammo available
@export var ammo: int
## Max amount of ammo
@export var max_ammo: int

@export var bullet_scn: PackedScene
@onready var shoot: AudioStreamPlayer2D = $Shoot

var facing_rotation = [0, 180, 90, 270]

func _ready():
	super()
	EventBus.pistol_ammo_update.emit(ammo)
	EventBus.pistol_ammo_upgrade.emit(max_ammo)

func attack(from: Vector2, dest: Vector2):
	if cooldown_timer.is_stopped() and ammo > 0:
		shoot.play()
		var bullet: Bullet = bullet_scn.instantiate()
		add_child(bullet)
		bullet.dir = dest
		bullet.rotate(deg_to_rad(get_bullet_rotation(dest)))
		ammo -= 1
		cooldown_timer.start(cooldown)
		if is_player:
			EventBus.pistol_ammo_update.emit(ammo)
		var r = raycast_to_damageable(from, dest)
		if r != null and r.is_in_group("Damageable"):
			hit.emit()
			r.take_damage(damage)

func reload(item: Item):
	if ammo < max_ammo:
		ammo = clampi(ammo + item.effect, 0, max_ammo)
		EventBus.pistol_ammo_update.emit(ammo)
		EventBus.item_used.emit(item)

func upgrade(item: Item):
	match item.type:
		Item.Item_type.PISTOL_DAMAGE_UPGRADE:
			damage *= 2
			EventBus.item_used.emit(item)
		Item.Item_type.PISTOL_FIRE_RATE_UPGRADE:
			# TODO: Update to when fire rate is implemented
			cooldown /= 2
			EventBus.item_used.emit(item)
			pass
		Item.Item_type.MAX_PISTOL_AMMO_UPGRADE:
			max_ammo += item.effect
			EventBus.pistol_ammo_upgrade.emit(max_ammo)
			EventBus.item_used.emit(item)

func get_bullet_rotation(dir: Vector2):
	match dir:
		Vector2.LEFT:
			return 90
		Vector2.RIGHT:
			return -90
		Vector2.UP:
			return 180
		_:
			return 0
	pass
