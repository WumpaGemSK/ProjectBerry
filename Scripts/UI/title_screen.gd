extends Control

var start : Button = null
var options : Button = null
var leaderboard : Button = null
var credits : Button = null
const TITLE_SCREEN_V_1_1 = preload("res://Assets/Audio/Music/Title Screen V1.1.wav")
## [PackedScene] to switch to when Start Game is pressed
@export var game_scene : PackedScene
## [PackedScene] Scene to switch to when Options is pressed
@export var options_scene : PackedScene
## [PackedScene] to switch to when Leaderboard is pressed
@export var leaderboard_scene :  PackedScene
## [PackedScene] to switch to when Credits is pressed
@export var credits_scene :  PackedScene

func _ready():
	
	start = find_child("StartGame")
	start.pressed.connect(_on_start_game)
	
	options = find_child("Options")
	options.pressed.connect(_on_options)
	
	leaderboard = find_child("Leaderboard")
	leaderboard.visible = FileAccess.file_exists(Constants.SAVE_FILE_PATH)
	leaderboard.pressed.connect(_on_leaderboard)
	
	credits = find_child("Credits")
	credits.pressed.connect(_on_credits)
	AudioManager.play_music(TITLE_SCREEN_V_1_1, 0)
	start.grab_focus()

func _on_start_game():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(game_scene)
	
func _on_options():
	get_tree().change_scene_to_packed(options_scene)
	
func _on_leaderboard():
	get_tree().change_scene_to_packed(leaderboard_scene)

func _on_credits():
	get_tree().change_scene_to_packed(credits_scene)
