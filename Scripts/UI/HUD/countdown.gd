extends Control

@onready var label : Label = %Label
@export var ease_mode : Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export var transition_type : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var timer: Timer = null

func _ready():
	modulate.a = 0
	if timer == null:
		timer = CountdownTimer.timer
	timer.stop()
	var tween = create_tween()
	tween.set_trans(transition_type)
	tween.set_ease(ease_mode)
	tween.tween_property(self, "modulate:a", 1, Constants.COUNDTDOWN_FADE_IN)
	tween.tween_callback(func(): EventBus.countdown_start.emit())

## Format the time left as minutes, seconds, miliseconds. Time left is in seconds
func format_time(time_left: float) -> String:
	var minutes : int = int(time_left / 60)
	var seconds : int = int(fmod(time_left, 60))
	var miliseconds : int = int(fmod(time_left, 1) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, miliseconds]

func update_label(time_left: float):
	label.text = format_time(time_left)

func _process(delta):
	update_label(timer.time_left)
