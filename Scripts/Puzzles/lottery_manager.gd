extends Node

signal puzzle_completed

@export var correct_flask: Flask

func _ready():
	correct_flask.interact.connect(on_interact)

func on_interact():
	puzzle_completed.emit()
