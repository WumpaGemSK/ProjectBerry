extends Node

## The selected code for the run
var selected_code: String
var shuffled_code: String
#region Secrets
## The maximum amount of secrets
var max_secret_amount: int = 5
## The amount of secrets picked up
var secret_count: int = 0
#endregion

## Time left in seconds to get ranked
var max_time_left: float = 900 # 15 minutes

var retries: int = 3

var score : GameScore = null
enum Ranking {
	D,
	C,
	B,
	A
}

enum Room {
	COMMAND,
	COMMUNICATIONS,
	STORAGE,
	TRAINING_ROOM,
	RESEARCH_LAB
}

func _ready():
	selected_code = Constants.CODES.pick_random()
	shuffled_code = shuffle_string(selected_code)
	EventBus.try_code.connect(on_code_try)
	EventBus.player_death.connect(on_player_death)
	EventBus.secret_pickup.connect(on_secret_pickup)
	EventBus.reset.connect(reset)

func on_code_try(code: String):
	if code == selected_code:
		score = GameScore.new()
		score = compute_score()
		EventBus.code_correct.emit(score)
		var next_scene: String = ""
		match score.ranking:
			Ranking.D:
				next_scene = "res://Scenes/Cutscenes/bad_ending.tscn"
			Ranking.C:
				next_scene = "res://Scenes/Cutscenes/neutral_ending.tscn"
			Ranking.B:
				next_scene = "res://Scenes/Cutscenes/good_ending.tscn"
			Ranking.A:
				next_scene = "res://Scenes/Cutscenes/best_ending.tscn"
				
		get_tree().change_scene_to_packed(load(next_scene))
	else:
		retries -= 1
		if retries > 0:
			EventBus.code_incorrect.emit()
		else:
			EventBus.continue_screen.emit()

func compute_score() -> GameScore:
	var time_taken = Constants.COUNTDOWN_TIME_SECONDS - CountdownTimer.time_left()
	score.ranking = compute_ranking(time_taken, secret_count, max_secret_amount)
	score.total_time = time_taken
	score.secrets.append_array([secret_count, max_secret_amount])
	return score

func compute_ranking(time_left: float, count: int, max_count: int) -> Ranking:
	var ranking: Ranking = Ranking.D
	if time_left >= max_time_left:
		ranking = Ranking.C
	if count == max_count and max_count != 0 or time_left < max_time_left:
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

func on_player_death():
	retries -= 1
	EventBus.continue_screen.emit()

func get_fax_item(room: Room) -> Resource:
	var item_scn: Resource = null
	var path = "res://Resources/Codes/%s.tres"
	item_scn = load(path % shuffled_code[room].to_lower())
	if item_scn:
		return item_scn
	else:
		return null

func shuffle_string(s: String):
	var a: Array = []
	for c in s:
		a.append(c)
	randomize()
	a.shuffle()
	return "".join(a)

func reset():
	selected_code = Constants.CODES.pick_random()
	shuffled_code = shuffle_string(selected_code)
	secret_count = 0
	retries = 3
	score = null
