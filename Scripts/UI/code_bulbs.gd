extends Control

@onready var incorrect_bulb = %IncorrectBulb
@onready var correct_bulb = %CorrectBulb

# NOTE: Need to think when to deactivate. On continue or after entering a new code
func _ready():
	EventBus.code_correct.connect(on_code_correct)
	EventBus.code_incorrect.connect(on_code_incorrect)

func on_code_correct(_score):
	AudioManager.play_effect(SoundEffect.SoundType.UI_CORRECT_CODE)
	correct_bulb.activate()
	incorrect_bulb.deactivate()

func on_code_incorrect():
	AudioManager.play_effect(SoundEffect.SoundType.UI_INCORECT_CODE)
	incorrect_bulb.activate()
	correct_bulb.deactivate()
