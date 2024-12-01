extends State

## The speed in which the enemy will patrol
@export var patrolling_speed: float = 20
## The path to follow by the enemy
@export var patrol_path : Path2D
var path_follow: PathFollow2D = null
var progress: float = 0.0
@onready var run = $Run

func enter(enemy: Enemy):
	enemy.movement_speed = patrolling_speed
	enemy.prompt.texture = null
	if path_follow == null:
		path_follow = PathFollow2D.new()
		patrol_path.add_child(path_follow)
	
func update(enemy: Enemy, delta: float):
	if not run.playing:
		run.play()
	progress += delta*patrolling_speed
	path_follow.progress = progress
	var new_pos = path_follow.global_position
	enemy.set_target_position(new_pos)
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

func on_hearing(body: Node2D, _enemy: Enemy):
	if body is Player:
		should_switch_to_investigating(body)
	
func on_view(body: Node2D, enemy: Enemy):
	if body is Player:
		if raycast_to_player(enemy.global_position, body.global_position, enemy.collision_mask, INF, [self]):
			state_change.emit(Enemy.States.CHASING)

func should_switch_to_investigating(player: Player):
	if player != null and not player.is_sneaking():
		state_change.emit(Enemy.States.INVESTIGATING)
