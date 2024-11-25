extends Control

@onready var timer = $Timer
@onready var tries = %Tries

func _ready():
	visible = false
	timer.timeout.connect(on_timeout)
	EventBus.pause.connect(on_pause)


func _input(event):
	if visible and event.is_action_type():
		visible = false
		timer.stop()
		EventBus.resume.emit()
		EventBus.retry_continue.emit()

func on_timeout():
	switch_to_game_over()

func switch_to_game_over():
	get_tree().change_scene_to_file.call_deferred("res://Scenes/GameOverScene.tscn")

func on_pause():
	var tries_left = Game.retries
	visible = true
	if tries_left > 0:
		tries.text = "%d tries left." % [tries_left]
		timer.start()
	else:
		switch_to_game_over()
