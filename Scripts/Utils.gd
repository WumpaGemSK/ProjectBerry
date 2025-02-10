class_name Utils


static func format_time(time_left: float) -> String:
	var minutes : int = int(time_left / 60)
	var seconds : int = int(fmod(time_left, 60))
	var miliseconds : int = int(fmod(time_left, 1) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, miliseconds]

static func ranking_to_string(ranking: Game.Ranking) -> String:
	return Game.Ranking.keys()[ranking]

static func layer_to_mask(layer_id: int) -> int:
	return 1 << (layer_id-1)

static func blink(tween: Tween, node: Node, iterations: int) -> Tween:
	for i in iterations*3:
		tween.tween_property(node, "modulate:a", 0.2, 0.10)
		tween.tween_property(node, "modulate:a", 1.0, 0.10)
	return tween
