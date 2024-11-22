extends Control

@onready var ranking: StatusLine = %Ranking
@onready var total_time: StatusLine = %"Total time"
@onready var secrets: StatusLine = %Secrets
@onready var initials = %Initials

var score: GameScore
# Called when the node enters the scene tree for the first time.
func _ready():
	score = Game.get_score()
	if score != null:
		ranking.set_data("Ranking", Utils.ranking_to_string(score.ranking))
		var time_string: String = Utils.format_time(score.total_time)
		total_time.set_data("Total time", time_string)
		secrets.set_data("Secrets", "%d/%d" % score.secrets)

func _on_leaderboad_button_pressed():
	if score != null:
		var text: String = initials.text
		score.initials = text.to_upper()
		EventBus.new_score.emit(score)
	get_tree().change_scene_to_packed(load("res://Scenes/UI/Leaderboard_UI.tscn"))
