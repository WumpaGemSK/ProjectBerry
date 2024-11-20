extends State

## Speed in which the enemy will investigate a sound
@export var investigating_speed: float

## The resource to set as the enemy prompt texture
var question_mark = preload("res://Assets/Textures/question_mark.tres")

func enter(enemy: Enemy):
	super(enemy)
	enemy.prompt.texture = question_mark
	enemy.set_target_position(enemy.player.global_position)
	enemy.movement_speed = investigating_speed
	enemy.prompt.texture = question_mark

func on_hearing(body: Node2D, _enemy: Enemy):
	if body is Player:
		if not body.is_sneaking:
			state_change.emit(Enemy.States.INVESTIGATING)
	
func on_view(body: Node2D, enemy: Enemy):
	if body is Player:
		if raycast_to_player(enemy.global_position, body.global_position, enemy.collision_mask, INF, [self]):
			state_change.emit(Enemy.States.CHASING)
