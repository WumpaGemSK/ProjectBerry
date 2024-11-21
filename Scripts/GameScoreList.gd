extends Resource
class_name GameScoreList

@export var scores: Array[GameScore]

func append(score: GameScore):
	scores.append(score)
