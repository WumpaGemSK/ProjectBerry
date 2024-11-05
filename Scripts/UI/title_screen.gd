extends Control

var start : Button = null
var options : Button = null
var leaderboard : Button = null

## [PackedScene] to switch to when Start Game is pressed
@export var game_scene : PackedScene
## [PackedScene] Scene to switch to when Options is pressed
@export var options_scene : PackedScene
## [PackedScene] to switch to when Leaderboard is pressed
@export var leaderboard_scene :  PackedScene

func _ready():
	start = find_child("StartGame")
	start.pressed.connect(_on_start_game)
	options = find_child("Options")
	options.pressed.connect(_on_options)
	leaderboard = find_child("Leaderboard")
	leaderboard.visible = FileAccess.file_exists(Constants.SAVE_FILE_PATH)
	leaderboard.pressed.connect(_on_leaderboard)

func _on_start_game():
	get_tree().change_scene_to_packed(game_scene)
	
func _on_options():
	get_tree().change_scene_to_packed(options_scene)
	
func _on_leaderboard():
	get_tree().change_scene_to_packed(leaderboard_scene)
