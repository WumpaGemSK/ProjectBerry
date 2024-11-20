extends State

## The speed in which the enemy will return to the resting position
@export var movement_speed: float

func enter(enemy: Enemy):
	enemy.set_target_position(enemy.resting_position)
	enemy.movement_speed = movement_speed
	enemy.prompt.texture = null

func update(enemy: Enemy, _delta: float):
	enemy.facing_direction = enemy.original_facing_dir
	
func on_hearing(body: Node2D, _enemy: Enemy):
	if body is Player:
		should_switch_to_investigating(body)
	
func on_view(body: Node2D, enemy: Enemy):
	if body is Player:
		if raycast_to_player(enemy.global_position, body.global_position, enemy.collision_mask, INF, [self]):
			state_change.emit(Enemy.States.CHASING)

func should_switch_to_investigating(player: Player):
	if player != null and not player.is_sneaking:
		state_change.emit(Enemy.States.INVESTIGATING)
