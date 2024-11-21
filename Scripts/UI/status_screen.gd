extends Control

@onready var ranking: StatusLine = %Ranking
@onready var total_time: StatusLine = %"Total time"
@onready var secrets: StatusLine = %Secrets

# Called when the node enters the scene tree for the first time.
func _ready():
	var score: GameScore = Game.get_score()
	if score != null:
		ranking.set_data("Ranking", Game.Ranking.keys()[score.ranking])
		var time_string: String = format_time(Constants.COUNTDOWN_TIME_SECONDS - score.time_left)
		total_time.set_data("Total time", time_string)
		secrets.set_data("Secrets", "%d/%d" % score.secrets)

func format_time(time_left: float) -> String:
	var minutes : int = int(time_left / 60)
	var seconds : int = int(fmod(time_left, 60))
	var miliseconds : int = int(fmod(time_left, 1) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, miliseconds]
