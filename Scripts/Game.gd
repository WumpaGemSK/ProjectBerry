extends Node

## The selected code for the run
var selected_code: String
## The maximum amount of secrets
var max_secret_amount: int = 0
## The amount of secrets picked up
var secret_count: int = 0
var status_scn: PackedScene = preload("res://Scenes/UI/StatusScreen.tscn")

## Time left in seconds to get ranked
var max_time_left: float = 60

var score : GameScore = null
enum Ranking {
	D,
	C,
	B,
	A
}

func _ready():
	selected_code = Constants.CODES.pick_random()
	EventBus.try_code.connect(on_code_try)

func on_code_try(code: String):
	if code == selected_code:
		score = GameScore.new()
		score = compute_score()
		EventBus.code_correct.emit(score)
		get_tree().change_scene_to_packed(status_scn)
	else:
		EventBus.code_incorrect.emit()

func compute_score() -> GameScore:
	var time_left = CountdownTimer.time_left()
	score.ranking = compute_ranking(time_left, secret_count, max_secret_amount)
	score.total_time = Constants.COUNTDOWN_TIME_SECONDS - CountdownTimer.time_left()
	score.secrets.append_array([secret_count, max_secret_amount])
	return score

func compute_ranking(time_left: float, count: int, max_count: int) -> Ranking:
	var ranking: Ranking = Ranking.D
	if time_left >= max_time_left:
		ranking = Ranking.C
	if count == max_count and max_count != 0:
		ranking = Ranking.B
	if time_left >= max_time_left and (count == max_count and max_count != 0):
		ranking = Ranking.A
	return ranking

func on_secret_pickup():
	secret_count += 1

func set_max_secret_amount(amount: int):
	max_secret_amount = amount

func get_score() -> GameScore:
	return score
