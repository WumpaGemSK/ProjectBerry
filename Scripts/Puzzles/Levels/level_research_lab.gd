extends Node2D

@onready var fax_machine = $FaxMachine
@onready var lottery_manager = $LotteryManager

# Called when the node enters the scene tree for the first time.
func _ready():
	lottery_manager.puzzle_completed.connect(on_puzzle_completed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_puzzle_completed():
	fax_machine.print_code()
