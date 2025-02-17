extends Node

var timer : Timer = null
var timer_medium : Timer = null
var timer_high : Timer = null
## Signal to update the timer UI
signal timer_tick(time_left : float)

## Signal when the timer runs out
signal time_run_out

#region Music
const GAMEPLAY_EVEN_FASTER_V_1_1 = preload("res://Assets/Audio/Music/Gameplay Even Faster V1.1.wav")
const GAMEPLAY_FASTER_V_1_1 = preload("res://Assets/Audio/Music/Gameplay Faster V1.1.wav")

const MEDIUM_MUSIC_TIME : float = 600 # 10 minutes in seconds
const HIGH_MUSIC_TIME : float = 1200 # 20 minutes in seconds
#endregion
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.name = "CountdownTimer"
	timer.wait_time = Constants.COUNTDOWN_TIME_SECONDS
	timer.autostart = false
	timer.one_shot = true
	timer.timeout.connect(on_timer_timeout)
	#EventBus.pause.connect(on_pause)
	#EventBus.resume.connect(on_resume)
	EventBus.countdown_start.connect(on_countdown_start)
	add_child(timer)
	timer_medium = Timer.new()
	add_child(timer_medium)
	timer_medium.name = "CountdownMediumIntensity"
	timer_medium.one_shot = true
	timer_medium.wait_time = MEDIUM_MUSIC_TIME
	timer_medium.timeout.connect(func(): AudioManager.play_music(GAMEPLAY_FASTER_V_1_1, 0))
	timer_high = Timer.new()
	add_child(timer_high)
	timer_high.name = "CountdownHighIntensity"
	timer_high.one_shot = true
	timer_high.wait_time = HIGH_MUSIC_TIME
	timer_high.timeout.connect(func(): AudioManager.play_music(GAMEPLAY_EVEN_FASTER_V_1_1, 0))

func on_countdown_start():
	timer.stop()
	timer.start()
	timer_high.start()
	timer_medium.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	timer_tick.emit(timer.time_left)

func on_timer_timeout():
	time_run_out.emit()

func on_pause():
	timer.paused = true
	
func on_resume():
	timer.paused = false

func time_left() -> float:
	timer.paused = true
	return timer.time_left
