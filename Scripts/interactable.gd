extends Node2D

signal interact

@onready var area_2d = $Area2D
@onready var prompt = %Prompt

var player_near: bool = false

func _ready():
	prompt.visible = false

func _input(event):
	if event.is_action_pressed("interact") and player_near:
		interact.emit()

func _on_area_2d_body_entered(body):
	prompt.visible = true
	player_near = true

func _on_area_2d_body_exited(body):
	prompt.visible = false
	player_near = false
