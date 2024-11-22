extends Control

@onready var entry_list = %EntryList
@onready var line_scn = preload("res://Scenes/UI/StatusLine.tscn")

func _ready():
	var scores_list: GameScoreList = Leaderboard.scores
	var scores = scores_list.return_sorted()
	for i in range(scores_list.scores.size()):
		var entry: StatusLine = line_scn.instantiate()
		var score: GameScore = scores_list.scores[i]
		entry_list.add_child(entry)
		entry.set_data("#%d  %s" % [i+1, Utils.ranking_to_string(score.ranking)], Utils.format_time(score.total_time))

func _on_button_pressed():
	get_tree().change_scene_to_packed(load("res://Scenes/UI/TitleScreen.tscn"))
