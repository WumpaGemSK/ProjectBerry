extends State

## Speed in which the enemy will investigate a sound
@export var investigating_speed: float = 20
@export var recheck_time: float = 0.5
@export var navigation_agent_2d : NavigationAgent2D

var timer: Timer = null
## The resource to set as the enemy prompt texture
var question_mark = preload("res://Assets/Textures/question_mark.tres")
var enemy: Enemy
var target: Vector2

func enter():
	enemy = get_parent()
	if timer == null:
		timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = recheck_time
		timer.autostart = false
		add_child(timer)
		timer.timeout.connect(on_recheck)
	enemy.prompt.texture = question_mark
	enemy.movement_speed = investigating_speed
	enemy.prompt.texture = question_mark
	target = enemy.player.global_position
	timer.start(recheck_time)
	enemy.change_speed.emit(investigating_speed)

func process(_delta: float):
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

func get_move_path(curr: Vector2) -> PackedVector2Array:
	var path =PathfindingManager.get_valid_path(curr, target)
	if path.is_empty():
		state_change.emit(Enemy.States.IDLE)
		return []
	else:
		return path

func exit():
	timer.stop()

func on_hearing_exit(body: Node2D):
	if body is Player:
		timer.stop()

func on_view(body: Node2D):
	if body is Player:
		if raycast_to_player(enemy.global_position, body.global_position, enemy.collision_mask, INF, [self]):
			state_change.emit(Enemy.States.CHASING)

func should_switch_to_investigating(player_: Player):
	timer.start(recheck_time)
	if not player_.is_sneaking():
		target = player_.global_position
		move_to.emit()

func on_recheck():
	should_switch_to_investigating(enemy.player)
