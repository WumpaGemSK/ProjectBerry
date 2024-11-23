extends Node

var scores: GameScoreList

func _ready():
	if ResourceLoader.exists(Constants.SAVE_FILE_PATH):
		scores = load(Constants.SAVE_FILE_PATH)
	else:
		scores = GameScoreList.new()
	EventBus.new_score.connect(on_new_score)
	
func on_new_score(score: GameScore):
	scores.append(score)
	var file_path = Constants.SAVE_FILE_PATH
	var error : Error = ResourceSaver.save(scores, file_path)
	if error != OK:
		print("Error saving scores ", error)
	else:
		print("Saved scores")
