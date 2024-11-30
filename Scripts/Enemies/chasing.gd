extends State

@export var chasing_speed: float = 20
@export var chasing_time: float = 3
@export var recheck_time: float = 0.5
var exclamation_mark = preload("res://Assets/Textures/exclamation_mark.tres")

var chasing_timer: Timer
var recheck_timer: Timer
# TODO: Prevent enemy from stop chasing after the timer runs out
func enter(enemy: Enemy):
	enemy.set_target_position(enemy.player.global_position)
	if chasing_timer == null:
		chasing_timer = Timer.new()
		add_child(chasing_timer)
		chasing_timer.timeout.connect(on_chasing_timeout)
		chasing_timer.one_shot = true
	if recheck_timer == null:
		recheck_timer = Timer.new()
		recheck_timer.one_shot = false
		recheck_timer.timeout.connect(on_recheck)
		add_child(recheck_timer)
	chasing_timer.start(chasing_time)
	recheck_timer.start(recheck_time)
	enemy.movement_speed = chasing_speed
	enemy.prompt.texture = exclamation_mark
	enemy.player.panic.emit()

func update(enemy: Enemy, _delta: float):
	enemy.set_target_position(enemy.player.global_position)
	# TODO: The enemy may shoot even if the player is not in range and will lose all it's ammo
	enemy.attack()
	var dir = enemy.facing_direction
	var animation = ""
	match dir:
		Enemy.facing.UP:
			animation = "chase_up"
		Enemy.facing.DOWN:
			animation = "chase_down"
		Enemy.facing.LEFT:
			animation = "chase_side"
			enemy.animated_sprite.flip_h = true
		Enemy.facing.RIGHT:
			enemy.animated_sprite.flip_h = false
			animation = "chase_side"
	enemy.animated_sprite.play(animation)
func exit():
	chasing_timer.stop()
	recheck_timer.stop()

func on_hearing(_body: Node2D, _enemy: Enemy):
	return

func on_view(_body: Node2D, _enemy: Enemy):
	recheck_timer.start(recheck_time)

func on_view_exit(_body: Node2D, _enemy: Enemy):
	recheck_timer.stop()

func on_chasing_timeout():
	state_change.emit(Enemy.States.IDLE)

func on_recheck():
	chasing_timer.start(chasing_time)
