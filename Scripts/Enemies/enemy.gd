extends CharacterBody2D
class_name Enemy

@onready var health_component = $HealthComponent
@onready var movement_component = $MovementComponent
@onready var lootdrop_component = $LootdropComponent

signal change_speed(new_speed: float)

var player: Player = null
var collision : CollisionShape2D = null

@onready var hearing = %Hearing
@onready var fov = %FOV
@export var rotation_speed : float = 1
@export var idle_state : State
@export var investigating_state: State
@export var chasing_state: State

@export_category("Drops")
@export var drops : Array[ItemDrop]

@export_category("Facing direction")
enum facing {RIGHT, LEFT, DOWN, UP}
var facing_direction := facing.RIGHT
@export var original_facing_dir : facing = facing.RIGHT
@onready var prompt = %Prompt

var facing_rotation = [0, 180, 90, 270]
var facing_vector = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]

var resting_position : Vector2
var movement_speed : float

@export_category("Weapon")
@export var weapon_scn: PackedScene
var weapon: Weapon

var animated_sprite: AnimatedSprite2D

var paused: bool = false
var dead: bool = false

#region Faze in
@export_category("Phase time")
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
	resting_position = global_position
	state = idle_state
	change_speed.connect(func(val): movement_component.speed = val)
	connect_state_signals()
	state.enter()
	prompt.texture = null
	player = get_tree().get_nodes_in_group("Player")[0]
	add_child(phase_in)
	EventBus.pause.connect(on_pause)
	EventBus.resume.connect(on_resume)
	phase_in.timeout.connect(func(): paused=false)
	facing_direction = original_facing_dir
	health_component.health_depleted.connect(func(): call_deferred("death"))
	movement_component.new_path_req.connect(new_path)

func new_path():
	movement_component.path = state.get_move_path(global_position)
	if movement_component.path.is_empty():
		to_idle_state()

func _process(delta):
	if paused or dead:
		return
	rotate_fov(delta)
	state.process(delta)
	if velocity == Vector2.ZERO:
		facing_direction = original_facing_dir

# Called every frame. 'delta' is the ealapsed time since the previous frame.
func _physics_process(_delta):
	if paused or dead:
		return
	on_velocity_computed(movement_component.step(global_position))

func on_hearing(body : Node2D):
	state.on_hearing(body)
	
func on_hearing_exit(body : Node2D):
	state.on_hearing_exit(body)
	
func on_view(body: Node2D):
	state.on_view(body)

func on_view_exit(body: Node2D):
	state.on_view_exit(body)

func take_damage(amount: int):
	AudioManager.play_effect_at(SoundEffect.SoundType.ENEMY_GETS_HURT, global_position)
	health_component.take_damage(amount)

func death():
	dead = true
	AudioManager.play_effect_at(SoundEffect.SoundType.ENEMY_GETS_HURT, global_position)
	animated_sprite.play("death")
	spawn_loot()
	await animated_sprite.animation_finished
	queue_free()

# TODO: Move to a "manager"?
func spawn_loot():
	var roll = randf()
	var item = null
	for drop in drops:
		if drop.probability >= roll:
			item = drop.item
	lootdrop_component.spawn_item(item, global_position)

func attack():
	weapon.attack(global_position, facing_vector[facing_direction])

# Needed for the signal
func to_idle_state():
	on_change_state(States.IDLE)

func on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	if safe_velocity == Vector2.ZERO:
		return
	facing_direction = direction_from_velocity(safe_velocity)
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

func on_change_state(new_state: States):
	state.exit()
	disconnect_state_signals()
	match new_state:
		States.IDLE:
			state = idle_state
		States.INVESTIGATING:
			state = investigating_state
		States.CHASING:
			state = chasing_state
	connect_state_signals()
	state.enter()
	movement_component.path = state.get_move_path(global_position)

func connect_state_signals():
	state.state_change.connect(on_change_state)
	state.move_to.connect(on_move_to)

func disconnect_state_signals():
	if state.state_change.is_connected(on_change_state):
		state.state_change.disconnect(on_change_state)
	if state.move_to.is_connected(on_move_to):
		state.move_to.disconnect(on_move_to)

func on_move_to():
	movement_component.path = state.get_move_path(global_position)

## Called by attacking weapon signal
func on_attack():
	pass

func on_pause():
	paused = true
	phase_in.stop()
	state.pause()

func on_resume():
	phase_in.start(phase_in_time)
	state.resume()
