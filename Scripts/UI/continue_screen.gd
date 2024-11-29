extends Control

@onready var timer = $Timer
@onready var tries = %Tries
var pause_input = true
var phase_in: Timer
func _ready():
	visible = false
	timer.timeout.connect(on_timeout)
	EventBus.continue_screen.connect(on_continue_screen)
	phase_in = Timer.new()
	add_child(phase_in)
	phase_in.stop()
	phase_in.timeout.connect(func(): pause_input=false)

func _input(event):
	if pause_input:
		return
	if visible and event.is_action_type():
		visible = false
		timer.stop()
		pause_input = true
		EventBus.resume.emit()
		EventBus.retry_continue.emit()

func on_timeout():
	switch_to_game_over()

func switch_to_game_over():
	get_tree().change_scene_to_file.call_deferred("res://Scenes/GameOverScene.tscn")

func on_continue_screen():
	var tries_left = Game.retries
	visible = true
	phase_in.start(1)
	if tries_left > 0:
		tries.text = "%d tries left." % [tries_left]
		timer.start()
	else:
		switch_to_game_over()
