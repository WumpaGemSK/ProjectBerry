extends Node2D

@onready var fax_machine = $FaxMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_puzzle_completed():
	fax_machine.print_code()
