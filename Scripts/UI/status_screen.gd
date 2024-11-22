extends Control

@onready var ranking: StatusLine = %Ranking
@onready var total_time: StatusLine = %"Total time"
@onready var secrets: StatusLine = %Secrets

# Called when the node enters the scene tree for the first time.
func _ready():
	var score: GameScore = Game.get_score()
	if score != null:
		ranking.set_data("Ranking", Utils.ranking_to_string(score.ranking))
		var time_string: String = Utils.format_time(score.total_time)
		total_time.set_data("Total time", time_string)
		secrets.set_data("Secrets", "%d/%d" % score.secrets)


func _on_leaderboad_button_pressed():
	get_tree().change_scene_to_packed(load("res://Scenes/UI/Leaderboard_UI.tscn"))
