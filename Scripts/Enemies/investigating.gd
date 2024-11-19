extends State

## Speed in which the enemy will investigate a sound
@export var investigating_speed: float

## The resource to set as the enemy prompt texture
var question_mark = preload("res://Assets/Textures/question_mark.tres")

func enter(enemy: Enemy):
	enemy.prompt.texture = question_mark
	enemy.set_target_position(enemy.player.global_position)
	enemy.movement_speed = investigating_speed
	enemy.prompt.texture = question_mark

func on_hearing(body: Node2D, enemy: Enemy):
	super(body, enemy)
	
func on_view(body: Node2D, enemy: Enemy):
	super(body, enemy)
