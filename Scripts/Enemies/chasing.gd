extends State

@export var chasing_speed: float
var exclamation_mark = preload("res://Assets/Textures/exclamation_mark.tres")

var chasing_timer: Timer
var is_in_view: bool = false
# TODO: Prevent enemy from stop chasing after the timer runs out
func enter(enemy: Enemy):
	enemy.set_target_position(enemy.player.global_position)
	if chasing_timer == null:
		chasing_timer = Timer.new()
		add_child(chasing_timer)
		chasing_timer.timeout.connect(on_chasing_timeout)
		chasing_timer.one_shot = true
	chasing_timer.start(5)
	enemy.movement_speed = chasing_speed
	enemy.prompt.texture = exclamation_mark
	is_in_view = true
	enemy.player.panic.emit()

func update(enemy: Enemy, _delta: float):
	enemy.set_target_position(enemy.player.global_position)
	enemy.attack()

func exit():
	chasing_timer.stop()

func on_hearing(_body: Node2D, _enemy: Enemy):
	return

func on_view_exit(body: Node2D, enemy: Enemy):
	is_in_view = false

func on_chasing_timeout():
	state_change.emit(Enemy.States.IDLE)
