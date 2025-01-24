extends Node

const BULLET = preload("res://Scenes/bullet.tscn")

func _ready():
	EventBus.fire_bullet.connect(on_fire_bullet)
	
func on_fire_bullet(from: Vector2, direction: Vector2, damage: int):
	var bullet = BULLET.instantiate()
	add_child(bullet)
	bullet.damage = damage
	bullet.dir = direction
	bullet.global_position = from + direction*35
	bullet.rotate(deg_to_rad(get_bullet_rotation(direction)))

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
