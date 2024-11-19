extends State

var timer : Timer = null
@export var chasing_speed: float
var exclamation_mark = preload("res://Assets/Textures/exclamation_mark.tres")

func enter(enemy: Enemy):
	if timer == null:
		timer = Timer.new()
		timer.wait_time = 5
		timer.timeout.connect(on_timeout)
		add_child(timer)
	enemy.set_target_position(enemy.player.global_position)
	timer.start(5)
	enemy.movement_speed = chasing_speed
	enemy.prompt.texture = exclamation_mark

func update(enemy: Enemy, delta: float):
	enemy.set_target_position(enemy.player.global_position)

func exit():
	timer.stop()

func on_hearing(body: Node2D, enemy: Enemy):
	return
	
func on_view(body: Node2D, enemy: Enemy):
	super(body, enemy)

func on_timeout():
	state_change.emit(Enemy.States.IDLE)
