extends Area2D
class_name HitboxComponent

signal damage_taken

@export var health_component : HealthComponent

func take_damage(amount : int) -> void:
	health_component.take_damage(amount)
	damage_taken.emit()
