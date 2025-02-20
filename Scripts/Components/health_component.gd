extends Node
class_name HealthComponent

signal health_changed(new_health: int)
signal health_depleted

@export var default_health: int
@export var max_health : int
var health : int : 
	set(value):
		health = value
		health_changed.emit(health)

var invulnerable : bool = false

func _ready():
	health = default_health

## Returns false if no damage was taken, true otherwise
func take_damage(amount: int) -> bool:
	if health <= 0 or invulnerable:
		return false
	health = clampi(health - amount, 0, max_health)
	if health <= 0:
		health_depleted.emit()
	return true

func heal(item: Item):
	if item.type != Item.Item_type.MEDIPACK:
		return
	if health < max_health:
		health = clampi(health + item.effect, 0, max_health)
		EventBus.item_used.emit(item)

func increase_max_health(item: Item):
	if item.type != Item.Item_type.SERUM:
		return
	max_health += 1
	health_changed.emit(health)
	EventBus.item_used.emit(item)

func reset_health():
	health = default_health
