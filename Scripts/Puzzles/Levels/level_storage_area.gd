extends Node2D

@onready var fax_machine = $NavigationRegion2D/FaxMachine
@onready var puzzle_complete_collider = $PuzzleCompleteCollider

func _ready():
	puzzle_complete_collider.body_entered.connect(on_puzzle_completed)

func on_puzzle_completed(body):
	if body is Player:
		fax_machine.print_code()
