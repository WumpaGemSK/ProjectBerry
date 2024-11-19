extends Node2D
class_name Weapon

signal attacking
signal hit

@onready var cooldown_timer : Timer
## How much time in seconds before attacking againg with the weapon
@export var cooldown : float = 1.0
## Range of the weapon in pixels
@export var range: float
## Damage caused by on attack of the weapon
@export var damage: int
## Is the weapon melee?
@export var is_melee: bool

func _ready():
	cooldown_timer = Timer.new()
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)

func attack(_from: Vector2, _direction: Vector2):
	return

func raycast_to_damageable(origin: Vector2, dir: Vector2):
	var dest : Vector2 = origin + dir*range
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(origin, dest)
	var result = space_state.intersect_ray(query)
	return result.collider if result.size() > 0 and result.position.distance_to(origin) < range else null

func reload(_amount: int) -> bool:
	return false
	
func upgrade(item: Item):
	return
