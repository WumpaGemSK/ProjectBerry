extends State

## The speed in which the enemy will return to the resting position
@export var movement_speed: float = 20
@export var recheck_time: float = 0.5
@export var navigation_agent_2d : NavigationAgent2D

var timer: Timer = null
var player: Player
var enemy: Enemy

func enter():
	enemy = get_parent()
	if timer == null:
		timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = recheck_time
		timer.autostart = false
		add_child(timer)
		timer.timeout.connect(on_recheck)
	enemy.movement_speed = movement_speed
	enemy.prompt.texture = null
	player = enemy.player
	if enemy.resting_position != global_position:
		navigation_agent_2d.set_target_position(enemy.resting_position)

func process(_delta: float):
	enemy.facing_direction = enemy.original_facing_dir
	var dir = enemy.facing_direction
	var animation = "idle_" if navigation_agent_2d.is_navigation_finished() else "walk_"
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
	
func physics_process(delta):
	var enemy : Enemy = get_parent()
	if NavigationServer2D.map_get_iteration_id(navigation_agent_2d.get_navigation_map()) == 0:
		return
	if navigation_agent_2d.is_navigation_finished():
		enemy.facing_direction = enemy.original_facing_dir
	var next_pos : Vector2 = navigation_agent_2d.get_next_path_position()
	var new_vel : Vector2 = global_position.direction_to(next_pos)*movement_speed*delta
	enemy.on_velocity_computed(new_vel)

func on_hearing(body: Node2D):
	if body is Player:
		should_switch_to_investigating(body)

func on_hearing_exit(body: Node2D):
	if body is Player:
		timer.stop()

func on_view(body: Node2D):
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
