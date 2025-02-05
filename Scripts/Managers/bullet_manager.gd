extends Node

const BULLET = preload("res://Scenes/bullet.tscn")

func _ready():
	EventBus.fire_bullet.connect(on_fire_bullet)
	
func on_fire_bullet(from: Vector2, direction: Vector2, damage: int, is_player: bool, knock_back_force: float):
	var bullet = BULLET.instantiate()
	add_child(bullet)
	bullet.damage = damage
	bullet.dir = direction
	bullet.global_position = from + direction
	bullet.knock_back = knock_back_force
	bullet.set_col_mask(Constants.ENEMY_LAYER if is_player else Constants.PLAYER_LAYER)
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
