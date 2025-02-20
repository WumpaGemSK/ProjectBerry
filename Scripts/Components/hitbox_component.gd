extends Area2D
class_name HitboxComponent

signal on_hit(amount: int, impact_dir: Vector2)

func take_damage(amount : int, impact_direction: Vector2 = Vector2.ZERO) -> void:
	on_hit.emit(amount, impact_direction)
