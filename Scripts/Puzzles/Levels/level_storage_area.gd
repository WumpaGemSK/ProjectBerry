extends Node2D

@onready var fax_machine = $FaxMachine
@onready var puzzle_complete_collider = $PuzzleCompleteCollider

func _ready():
	puzzle_complete_collider.body_entered.connect(on_puzzle_completed)

func on_puzzle_completed():
	fax_machine.print_code()
