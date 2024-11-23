extends Resource
class_name GameScoreList

@export var scores: Array[GameScore]

func append(score: GameScore):
	scores.append(score)

func return_sorted() -> Array[GameScore]:
	scores.sort_custom(GameScore.order)
	return scores
