extends Area2D
class_name HitboxComponent

signal damage_taken(impact_dir: Vector2)

@export var health_component : HealthComponent

func take_damage(amount : int, impact_direction: Vector2 = Vector2.ZERO) -> void:
	if health_component.invulnerable:
		return
	health_component.take_damage(amount)
	damage_taken.emit(impact_direction)
