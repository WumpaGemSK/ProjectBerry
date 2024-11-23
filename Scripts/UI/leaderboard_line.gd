extends Control

@onready var number = %Number
@onready var rank = %Rank
@onready var initials = %Initials
@onready var total_time = %TotalTime

var selected: bool = false

func set_score(index: int, score: GameScore):
	number.text = "#%d" % index
	rank.text = Utils.ranking_to_string(score.ranking)
	initials.text = score.initials
	total_time.text = Utils.format_time(score.total_time)
