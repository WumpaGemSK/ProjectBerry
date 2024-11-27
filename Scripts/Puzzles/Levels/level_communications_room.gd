extends Node2D

@onready var fax_machine = $FaxMachine
@onready var switch_manager = $SwitchManager

# Called when the node enters the scene tree for the first time.
func _ready():
	switch_manager.puzzle_complete.connect(on_puzzle_completed)

func on_puzzle_completed():
	fax_machine.print_code()
