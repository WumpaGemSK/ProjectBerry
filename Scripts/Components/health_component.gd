extends Node
class_name HealthComponent

signal health_changed(new_health: int)
signal death

@export var default_health: int = 3
@export var max_health : int = 5
var health : int = default_health : 
	set(value):
		health = value
		health_changed.emit(health)

var invulnerable : bool = false

func take_damage(amount: int):
	if health <= 0:
		return
	health = clampi(health - amount, 0, max_health)
	if health <= 0:
		death.emit()

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
