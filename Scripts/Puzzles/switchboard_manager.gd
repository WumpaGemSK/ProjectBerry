extends Node

signal puzzle_complete

var toggled_switches: int = 0
var total_switches: int = 0

func _ready():
	total_switches = get_child_count()
	for child: Switchboard in get_children():
		toggled_switches += 1 if child.active else 0
		child.toggled_many.connect(on_toggled)

func on_toggled(states: Array[bool]):
	for state in states:
		toggled_switches += 1 if state else -1
	if toggled_switches == total_switches:
		puzzle_complete.emit()
