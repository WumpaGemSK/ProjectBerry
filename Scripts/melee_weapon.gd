extends Weapon

func attack(from: Vector2, dest: Vector2):
	if cooldown_timer.is_stopped():
		var r = raycast_to_damageable(from, dest)
		if r.size() > 0:
			var result = r.collider
			if result != null and result.is_in_group("Damageable") and result.position.distance_to(from) < weapon_range:
				attacking.emit()
				var hitbox = result.get_node("HitboxComponent")
				if hitbox:
					hitbox.take_damage(damage, (-r.normal)*knockback_force)
		cooldown_timer.start(cooldown)
		AudioManager.play_effect(SoundEffect.SoundType.CRICKET_BAT_HIT)
		
func upgrade(item: Item):
	match item.type:
		Item.Item_type.BARBED_WIRE_UPGRADE:
			damage *= 2
			EventBus.item_used.emit(item)
