extends Control

@onready var incorrect_bulb = %IncorrectBulb
@onready var correct_bulb = %CorrectBulb
@onready var correct_sound = $CorrectSound
@onready var incorrect_sound = $IncorrectSound

# NOTE: Need to think when to deactivate. On continue or after entering a new code
func _ready():
	EventBus.code_correct.connect(on_code_correct)
	EventBus.code_incorrect.connect(on_code_incorrect)

func on_code_correct(_score):
	correct_sound.play()
	correct_bulb.activate()
	incorrect_bulb.deactivate()

func on_code_incorrect():
	incorrect_sound.play()
	incorrect_bulb.activate()
	correct_bulb.deactivate()
