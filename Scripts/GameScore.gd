extends Resource
class_name GameScore

@export var ranking: Game.Ranking
	## Time left in seconds
@export var total_time: float
	## Two element array: First the number of secrets found, second the total amount of secrets
@export var secrets: Array[int] 
