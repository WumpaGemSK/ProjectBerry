extends Node2D

@onready var terminal = $Desk/Terminal
@onready var terminal_ui = $CanvasLayer/Terminal_UI

func _ready():
	terminal.interact.connect(on_terminal_interact)

func on_terminal_interact():
	EventBus.open_terminal.emit()
