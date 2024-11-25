extends Node

signal puzzle_complete
var total_mines: int

func _ready():
	for child in get_children():
		if child.steps > 0:
			total_mines += 1
			child.deactivated.connect(on_mine_deactivated)

func on_mine_deactivated():
	total_mines -= 1
	if total_mines == 0:
		puzzle_complete.emit()
