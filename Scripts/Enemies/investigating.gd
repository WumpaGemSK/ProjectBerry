extends State

## Speed in which the enemy will investigate a sound
@export var investigating_speed: float = 20
@export var recheck_time: float = 0.5

var timer: Timer = null
## The resource to set as the enemy prompt texture
var question_mark = preload("res://Assets/Textures/question_mark.tres")
var unit: Enemy

func enter(enemy: Enemy):
	if timer == null:
		timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = recheck_time
		timer.autostart = false
		add_child(timer)
		timer.timeout.connect(on_recheck)
	enemy.prompt.texture = question_mark
	enemy.set_target_position(enemy.player.global_position)
	enemy.movement_speed = investigating_speed
	enemy.prompt.texture = question_mark
	unit = enemy
	timer.start(recheck_time)

func update(enemy: Enemy, delta: float):
	AudioManager.play_effect_at(SoundEffect.SoundType.ENEMY_RUN, enemy.global_position)
	var dir = enemy.facing_direction
	var animation = ""
	match dir:
		Enemy.facing.UP:
			animation = "walk_up"
		Enemy.facing.DOWN:
			animation = "walk_down"
		Enemy.facing.LEFT:
			animation = "walk_side"
			enemy.animated_sprite.flip_h = true
		Enemy.facing.RIGHT:
			enemy.animated_sprite.flip_h = false
			animation = "walk_side"
	enemy.animated_sprite.play(animation)

func exit():
	timer.stop()

func on_hearing_exit(body: Node2D, _enemy: Enemy):
	if body is Player:
		timer.stop()

func on_view(body: Node2D, enemy: Enemy):
	if body is Player:
		if raycast_to_player(enemy.global_position, body.global_position, enemy.collision_mask, INF, [self]):
			state_change.emit(Enemy.States.CHASING)

func should_switch_to_investigating(player_: Player):
	timer.start(recheck_time)
	if not player_.is_sneaking():
		unit.set_target_position(unit.player.global_position)

func on_recheck():
	should_switch_to_investigating(unit.player)
