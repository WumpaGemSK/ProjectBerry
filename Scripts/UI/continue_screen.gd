extends Control

@onready var timer = $Timer

func _ready():
	if Game.retries > 0:
		timer.start()
	else:
		print("Game over")
