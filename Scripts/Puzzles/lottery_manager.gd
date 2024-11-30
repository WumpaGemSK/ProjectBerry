extends Node

signal puzzle_completed

@export_group("Correct flask")
@export var correct_flask: Flask
@export var correct_line_renderer: Node2D

@export_group("Other flasks")
@export var other_flask: Flask
@export var other_line_renderer: Node2D
@export var other_flask2: Flask
@export var other_line_renderer2: Node2D
@export var other_flask3: Flask
@export var other_line_renderer3: Node2D

var playing: bool = false

func _ready():
	correct_flask.interact.connect(on_interact)
	correct_line_renderer.animation_finished.connect(on_animation_finished)
	other_flask.interact.connect(on_other_interact)
	other_flask2.interact.connect(on_other_interact2)
	other_flask3.interact.connect(on_other_interact3)
	other_line_renderer.animation_finished.connect(anim_finished)
	other_line_renderer2.animation_finished.connect(anim_finished)
	other_line_renderer3.animation_finished.connect(anim_finished)

func on_interact():
	if playing:
		return
	correct_line_renderer.render_line()
	playing = true

func on_animation_finished():
	anim_finished()
	puzzle_completed.emit()

func on_other_interact():
	if playing:
		return
	other_line_renderer.render_line()
	playing = true

func on_other_interact2():
	if playing:
		return
	other_line_renderer2.render_line()
	playing = true
	
func on_other_interact3():
	if playing:
		return
	other_line_renderer3.render_line()
	playing = true

func anim_finished():
	playing = false
	other_line_renderer.clear()
	other_line_renderer2.clear()
	other_line_renderer3.clear()
