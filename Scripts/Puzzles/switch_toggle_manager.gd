extends Node

signal puzzle_completed
@export var toggle_order: Array[SwitchToggle]

var current: int

func _ready():
	if toggle_order.is_empty():
		print("Empty order array. Please add the nodes in order of activation")
		return
	reset()

func on_activated():
	toggle_order[current].activated.disconnect(on_activated)
	toggle_order[current].toggled.connect(on_toggled)
	current += 1
	if current < toggle_order.size():
		toggle_order[current].toggled.disconnect(on_toggled)
		toggle_order[current].activated.connect(on_activated)
	else:
		puzzle_completed.emit()

func on_toggled(state: bool):
	reset()

func reset():
	if toggle_order[current].activated.is_connected(on_activated):
		toggle_order[current].activated.disconnect(on_activated)
	for switch in toggle_order:
		switch.reset()
		if not switch.toggled.is_connected(on_toggled):
			switch.toggled.connect(on_toggled)
	toggle_order[0].activated.connect.call_deferred(on_activated)
	toggle_order[0].toggled.disconnect(on_toggled)
	current = 0
	print("reset")
