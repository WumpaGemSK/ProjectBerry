extends CharacterBody2D
class_name Enemy

@export var health : int
var player: Player = null
var collision : CollisionShape2D = null

@onready var hearing = %Hearing
@onready var fov = %FOV
@onready var navigation_agent_2d = $NavigationAgent2D
@export var rotation_speed : float
@export var idle_state : State
@export var investigating_state: State
@export var chasing_state: State

enum facing {RIGHT, LEFT, DOWN, UP}
var facing_direction := facing.RIGHT
@export var original_facing_dir : facing = facing.RIGHT
@onready var prompt = %Prompt

var facing_rotation = [0, 180, 90, 270]
var facing_vector = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]

var resting_position : Vector2
var target_position : Vector2
var movement_speed : float

@export var weapon_scn: PackedScene
var weapon: Weapon

var animated_sprite: AnimatedSprite2D

var paused: bool = false

#region Faze in
@onready var phase_in : Timer = Timer.new()
@export var phase_in_time: float = 1.0
#endregion

enum States {
	IDLE,
	INVESTIGATING,
	CHASING
}
var state : State
# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite = get_node("AnimatedSprite2D")
	weapon = weapon_scn.instantiate()
	weapon.is_player = false
	add_child(weapon)
	weapon.attacking.connect(on_attack)
	idle_state.state_change.connect(change_state)
	investigating_state.state_change.connect(change_state)
	chasing_state.state_change.connect(change_state)
	resting_position = global_position
	state = idle_state
	prompt.texture = null
	player = get_tree().get_nodes_in_group("Player")[0]
	change_state(States.IDLE)
	hearing.body_entered.connect(on_hearing)
	hearing.body_exited.connect(on_hearing_exit)
	fov.body_entered.connect(on_view)
	fov.body_exited.connect(on_view_exit)
	navigation_agent_2d.velocity_computed.connect(on_velocity_computed)
	EventBus.pause.connect(func(): paused = true)
	EventBus.resume.connect(func(): phase_in.start(phase_in_time))
	phase_in.timeout.connect(func(): paused=false)
	add_child(phase_in)

func _process(delta):
	if paused:
		return
	rotate_fov(delta)
	state.update(self, delta)

# Called every frame. 'delta' is the ealapsed time since the previous frame.
func _physics_process(delta):
	if paused:
		return
	if NavigationServer2D.map_get_iteration_id(navigation_agent_2d.get_navigation_map()) == 0:
		return
	if navigation_agent_2d.is_navigation_finished():
		if state != idle_state:
			change_state(States.IDLE)
		return

	var next_pos : Vector2 = navigation_agent_2d.get_next_path_position()
	var new_vel : Vector2 = global_position.direction_to(next_pos)*movement_speed*delta
	on_velocity_computed(new_vel)

func on_hearing(body : Node2D):
	state.on_hearing(body, self)
	
func on_hearing_exit(body : Node2D):
	state.on_hearing_exit(body, self)
	
func on_view(body: Node2D):
	state.on_view(body, self)

func on_view_exit(body: Node2D):
	state.on_view_exit(body, self)

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		death()

func death():
	print("enemy death")
	pass

func attack():
	weapon.attack(global_position, facing_vector[facing_direction])

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

func rotate_fov(delta: float):
	var new_angle = deg_to_rad(facing_rotation[facing_direction])
	var new_rotation = lerp_angle(fov.rotation, new_angle, delta*rotation_speed)
	fov.rotation = new_rotation

func change_state(new_state: States):
	state.exit()
	match new_state:
		States.IDLE:
			state = idle_state
		States.INVESTIGATING:
			state = investigating_state
		States.CHASING:
			state = chasing_state
	state.enter(self)

## Called by attacking weapon signal
func on_attack():
	pass
