extends Node

signal puzzle_complete
var total_mines: int

func _ready():
	mines_left()
	EventBus.reload_scene.connect(mines_left)

func on_mine_deactivated():
	total_mines -= 1
	if total_mines == 0:
		puzzle_complete.emit()

func mines_left():
	total_mines = 0
	for child in get_children():
		if child.steps > 0:
			total_mines += 1
			if not child.deactivated.is_connected(on_mine_deactivated):
				child.deactivated.connect(on_mine_deactivated)
