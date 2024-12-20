extends Node

var timer : Timer = null

## Signal to update the timer UI
signal timer_tick(time_left : float)

## Signal when the timer runs out
signal time_run_out

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

func on_countdown_start():
	timer.stop()
	timer.start()
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
