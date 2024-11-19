extends State

@export var investigating_speed: float

var question_mark = preload("res://Assets/Textures/question_mark.tres")

func enter(enemy: Enemy):
	enemy.prompt.texture = question_mark
	enemy.set_target_position(enemy.player.global_position)
	enemy.movement_speed = investigating_speed
	enemy.prompt.texture = question_mark

func on_hearing(body: Node2D, enemy: Enemy):
	if body is Player:
		if not enemy.player.is_sneaking and enemy.state != enemy.chasing_state:
			state_change.emit(Enemy.States.INVESTIGATING)
	
func on_view(body: Node2D, enemy: Enemy):
	if body is Player:
		if enemy.raycast_to_player(INF):
			state_change.emit(Enemy.States.CHASING)
