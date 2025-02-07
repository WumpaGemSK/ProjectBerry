extends State

## The speed in which the enemy will patrol
@export var patrolling_speed: float = 20
## The path to follow by the enemy
@export var patrol_path : Path2D
@export var recheck_time: float = 0.5
var path_follow: PathFollow2D = null
var progress: float = 0.0
var enemy: Enemy
var timer: Timer = null

func enter():
	enemy = get_parent()
	enemy.movement_speed = patrolling_speed
	enemy.prompt.texture = null
	if path_follow == null:
		path_follow = PathFollow2D.new()
		patrol_path.add_child(path_follow)
	progress += patrolling_speed
	path_follow.progress = progress
	enemy.change_speed.emit(patrolling_speed)
	if timer == null:
		timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = recheck_time
		timer.autostart = false
		add_child(timer)
		timer.timeout.connect(should_switch_to_investigating)
	
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

func exit():
	timer.stop()

func get_move_path(curr: Vector2) -> PackedVector2Array:
	progress += patrolling_speed
	path_follow.progress = progress
	return PathfindingManager.get_valid_path(curr, path_follow.global_position)

func on_hearing(body: Node2D):
	if body is Player:
		timer.start(recheck_time)
		should_switch_to_investigating()

func on_view(body: Node2D):
	if body is Player:
		if raycast_to_player(enemy.global_position, body.global_position, enemy.collision_mask, INF, [self]):
			state_change.emit(Enemy.States.CHASING)

func should_switch_to_investigating():
	timer.start(recheck_time)
	if not enemy.player.is_sneaking():
		state_change.emit(Enemy.States.INVESTIGATING)
