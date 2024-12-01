extends Node2D

@onready var terminal = $Desk/Terminal
@onready var terminal_ui = $CanvasLayer/Terminal_UI
const GAMEPLAY_V_1_1 = preload("res://Assets/Audio/Music/Gameplay V1.1.wav")
func _ready():
	AudioManager.play_music(GAMEPLAY_V_1_1, 0)
	terminal.interact.connect(on_terminal_interact)

func on_terminal_interact():
	EventBus.open_terminal.emit()
