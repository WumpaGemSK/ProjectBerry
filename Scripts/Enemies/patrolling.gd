extends State

@export var patrolling_speed: float
@export var patrol_path : Path2D
var path_follow: PathFollow2D = null
var progress: float = 0.0

func enter(enemy: Enemy):
	enemy.movement_speed = patrolling_speed
	enemy.prompt.texture = null
	path_follow = PathFollow2D.new()
	patrol_path.add_child(path_follow)
	
func update(enemy: Enemy, delta: float):
	progress += delta*patrolling_speed
	path_follow.progress = progress
	var new_pos = path_follow.global_position
	enemy.set_target_position(new_pos)

func on_hearing(body: Node2D, enemy: Enemy):
	super(body, enemy)
	
func on_view(body: Node2D, enemy: Enemy):
	super(body, enemy)
