extends Control

@export var line_scn : PackedScene
@export var title_screen_scn : PackedScene
@onready var paginated_leaderboard = %PaginatedLeaderboard

func _ready():
	var scores_list: GameScoreList = Leaderboard.scores
	var scores = scores_list.return_sorted()
	paginated_leaderboard.set_elements(scores)

func _on_button_pressed():
	get_tree().change_scene_to_packed(title_screen_scn)
