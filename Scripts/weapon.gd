extends Node2D
class_name Weapon

@warning_ignore("unused_signal")
signal attacking

@warning_ignore("unused_signal")
signal hit

@onready var cooldown_timer : Timer
## How much time in seconds before attacking againg with the weapon
@export var cooldown : float = 1.0
## Range of the weapon in pixels
@export var weapon_range: float
## Damage caused by on attack of the weapon
@export var damage: int
## Is the weapon melee?
@export var is_melee: bool
var is_player: bool

func _ready():
	cooldown_timer = Timer.new()
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)

func attack(_from: Vector2, _direction: Vector2):
	return

func raycast_to_damageable(origin: Vector2, dir: Vector2):
	var dest : Vector2 = origin + dir*weapon_range
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(origin, dest)
	var result = space_state.intersect_ray(query)
	return result.collider if result.size() > 0 and result.position.distance_to(origin) < weapon_range else null

func reload(_item: Item):
	return
	
func upgrade(_item: Item):
	return
