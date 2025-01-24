extends State

## The speed in which the enemy will patrol
@export var patrolling_speed: float = 20
## The path to follow by the enemy
@export var patrol_path : Path2D
@export var navigation_agent_2d : NavigationAgent2D
var path_follow: PathFollow2D = null
var progress: float = 0.0
var enemy: Enemy

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
	progress += patrolling_speed
	path_follow.progress = progress
	return PathfindingManager.get_valid_path(curr, path_follow.global_position)

func on_hearing(body: Node2D):
	if body is Player:
		should_switch_to_investigating(body)
	
func on_view(body: Node2D):
	if body is Player:
		if raycast_to_player(enemy.global_position, body.global_position, enemy.collision_mask, INF, [self]):
			state_change.emit(Enemy.States.CHASING)

func should_switch_to_investigating(player: Player):
	if player != null and not player.is_sneaking():
		state_change.emit(Enemy.States.INVESTIGATING)
