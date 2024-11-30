extends State

## The speed in which the enemy will return to the resting position
@export var movement_speed: float = 20
@export var recheck_time: float = 0.5

var timer: Timer = null
var player: Player

func enter(enemy: Enemy):
	if timer == null:
		timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = recheck_time
		timer.autostart = false
		add_child(timer)
		timer.timeout.connect(on_recheck)
	enemy.set_target_position(enemy.resting_position)
	enemy.movement_speed = movement_speed
	enemy.prompt.texture = null
	player = enemy.player

func update(enemy: Enemy, _delta: float):
	enemy.facing_direction = enemy.original_facing_dir
	var dir = enemy.facing_direction
	var animation = "idle_" if enemy.velocity == Vector2.ZERO else "walk_"
	match dir:
		Enemy.facing.UP:
			animation += "up"
		Enemy.facing.DOWN:
			animation += "down"
		Enemy.facing.LEFT:
			animation += "side"
			enemy.animated_sprite.flip_h = true
		Enemy.facing.RIGHT:
			enemy.animated_sprite.flip_h = false
			animation += "side"
	enemy.animated_sprite.play(animation)
	
func on_hearing(body: Node2D, _enemy: Enemy):
	if body is Player:
		should_switch_to_investigating(body)

func on_hearing_exit(body: Node2D, _enemy: Enemy):
	if body is Player:
		timer.stop()

func on_view(body: Node2D, enemy: Enemy):
	if body is Player:
		if raycast_to_player(enemy.global_position, body.global_position, enemy.collision_mask, INF, [self]):
			state_change.emit(Enemy.States.CHASING)

func should_switch_to_investigating(player_: Player):
	timer.start(recheck_time)
	if player_ != null and not player_.is_sneaking():
		timer.stop()
		state_change.emit(Enemy.States.INVESTIGATING)

func on_recheck():
	should_switch_to_investigating(player)
