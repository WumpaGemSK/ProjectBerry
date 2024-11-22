class_name Utils


static func format_time(time_left: float) -> String:
	var minutes : int = int(time_left / 60)
	var seconds : int = int(fmod(time_left, 60))
	var miliseconds : int = int(fmod(time_left, 1) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, miliseconds]

static func ranking_to_string(ranking: Game.Ranking) -> String:
	return Game.Ranking.keys()[ranking]
