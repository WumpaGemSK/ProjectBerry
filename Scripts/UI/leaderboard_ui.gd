extends Control

@export var line_scn : PackedScene
@onready var paginated_leaderboard = %PaginatedLeaderboard

func _ready():
	var scores_list: GameScoreList = Leaderboard.scores
	var scores = scores_list.return_sorted()
	paginated_leaderboard.set_elements(scores)

func _on_button_pressed():
	# Hardcoded as using an exported packed scene broke TitleScreen and LeaderboardUI scenes for some reason
	get_tree().change_scene_to_packed(load("res://Scenes/UI/TitleScreen.tscn"))
