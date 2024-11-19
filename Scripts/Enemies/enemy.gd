extends CharacterBody2D

@export var health : int
var player: Player = null
var collision : CollisionShape2D = null

@onready var hearing = %Hearing
@onready var fov = %FOV
@onready var navigation_agent_2d = $NavigationAgent2D
@export var investigating_speed : float
@export var chasing_speed : float
@export var rotation_speed : float

var question_mark = preload("res://Assets/Textures/question_mark.tres")
var exclamation_mark = preload("res://Assets/Textures/exclamation_mark.tres")

enum facing {RIGHT, LEFT, DOWN, UP}
var facing_direction := facing.RIGHT
@export var original_facing_dir : facing = facing.RIGHT
@onready var prompt = %Prompt

var facing_rotation = [0, 180, 90, 270]
var facing_vector = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]

var resting_position : Vector2
var target_position : Vector2
var timer : Timer
var movement_speed
enum States {
	IDLE,
	INVESTIGATING,
	CHASING
}
@export var patrol_path : Path2D = null
var path_follow: PathFollow2D = null
var state : States = States.IDLE
# Called when the node enters the scene tree for the first time.
func _ready():
	prompt.texture = null
	movement_speed = investigating_speed
	timer = Timer.new()
	timer.wait_time = 5
	timer.timeout.connect(to_idle_state)
	add_child(timer)
	player = get_tree().get_nodes_in_group("Player")[0]
	hearing.body_entered.connect(on_hearing)
	fov.body_entered.connect(on_view)
	resting_position = global_position
	navigation_agent_2d.velocity_computed.connect(on_velocity_computed)
	if patrol_path == null:
		patrol_path = Path2D.new()
		patrol_path.curve = Curve2D.new()
		patrol_path.curve.add_point(resting_position)
		add_child(patrol_path)
	path_follow = PathFollow2D.new()
	patrol_path.add_child(path_follow)

func _process(delta):
	rotate_fov(delta)
	match state:
		States.CHASING:
			set_target_position(player.global_position)

# Called every frame. 'delta' is the ealapsed time since the previous frame.
func _physics_process(delta):
	if NavigationServer2D.map_get_iteration_id(navigation_agent_2d.get_navigation_map()) == 0:
		return
	if navigation_agent_2d.is_navigation_finished():
		if state != States.IDLE:
			change_state(States.IDLE)
		else:
			facing_direction = original_facing_dir
			path_follow.progress += delta*movement_speed
			var new_pos = path_follow.global_position
			set_target_position(new_pos)
		return

	var next_pos : Vector2 = navigation_agent_2d.get_next_path_position()
	var new_vel : Vector2 = global_position.direction_to(next_pos)*movement_speed
	on_velocity_computed(new_vel)

func on_hearing(body : Node2D):
	if body is Player:
		if not player.is_sneaking and state != States.CHASING:
			change_state(States.INVESTIGATING)

func on_view(body: Node2D):
	#TODO: Move timer start to body_exited?
	if body is Player:
		if raycast_to_player(INF):
			change_state(States.CHASING)

# Needed for the signal
func to_idle_state():
	change_state(States.IDLE)

func set_target_position(target: Vector2):
	navigation_agent_2d.set_target_position(target)

func on_velocity_computed(safe_velocity: Vector2):
	if safe_velocity == Vector2.ZERO:
		return
	facing_direction = direction_from_velocity(safe_velocity)
	var new_dir = facing_vector[facing_direction]
	velocity = new_dir*movement_speed
	move_and_slide()

func direction_from_velocity(vel: Vector2):
	if abs(vel.x) > abs(vel.y):
		if vel.x > 0:
			return facing.RIGHT
		else:
			return facing.LEFT
	else:
		if vel.y > 0:
			return facing.DOWN
		else:
			return facing.UP

func raycast_to_player(max_distance: float)-> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position, collision_mask, [self])
	var result = space_state.intersect_ray(query)
	return result.collider is Player and global_position.distance_to(player.global_position) < max_distance

func rotate_fov(delta: float):
	var new_angle = deg_to_rad(facing_rotation[facing_direction])
	var new_rotation = lerp_angle(fov.rotation, new_angle, delta*rotation_speed)
	fov.rotation = new_rotation

func change_state(new_state: States):
	match new_state:
		States.IDLE:
			state = States.IDLE
			timer.stop()
			set_target_position(resting_position)
			movement_speed = investigating_speed
			prompt.texture = null
		States.INVESTIGATING:
			state = States.INVESTIGATING
			set_target_position(player.global_position)
			movement_speed = investigating_speed
			prompt.texture = question_mark
		States.CHASING:
			state = States.CHASING
			set_target_position(player.global_position)
			timer.start(5)
			movement_speed = chasing_speed
			prompt.texture = exclamation_mark