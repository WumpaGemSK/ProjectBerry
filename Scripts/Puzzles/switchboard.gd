extends Switch
class_name Switchboard

## Sends the state of the switch after the toggle
signal toggled_many(state: Array[bool])

@export var neighbor1: Switchboard
@export var neighbor2: Switchboard

## Toggle the neighbors and itself, collect the new states and send the signal with the states.
## The interacted Switch is the responsible of sending the signal
func _on_interactable_interact():
	var states: Array[bool] = []
	states.append(toggle())
	states.append(neighbor1.toggle())
	states.append(neighbor2.toggle())
	toggled_many.emit(states)
