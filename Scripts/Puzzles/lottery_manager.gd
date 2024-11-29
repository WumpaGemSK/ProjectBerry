extends Node

signal puzzle_completed

@export var correct_flask: Flask
@onready var line_renderer = %LineRenderer

func _ready():
	correct_flask.interact.connect(on_interact)
	line_renderer.animation_finished.connect(on_animation_finished)

func on_interact():
	line_renderer.render_line()

func on_animation_finished():
	puzzle_completed.emit()
