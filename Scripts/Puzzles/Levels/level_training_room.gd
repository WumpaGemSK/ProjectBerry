extends Node2D

@onready var mine_manager = $MineManager
@onready var fax_machine = $FaxMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	mine_manager.puzzle_complete.connect(on_puzzle_complete)

func on_puzzle_complete():
	fax_machine.print_code()
