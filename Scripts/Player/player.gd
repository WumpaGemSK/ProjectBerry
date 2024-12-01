extends CharacterBody2D
class_name Player

@warning_ignore("unused_signal")
signal panic

@warning_ignore("unused_signal")
signal calm

signal equipped_weapon(weapon: Item)
signal health_changed(new_health: int)

@onready var my_animated_sprite := $AnimatedSprite2D
@onready var canvas_layer = $CanvasLayer

#movement variables
var direction : Vector2
@export var normal_speed : float = 100
@export var sneaking_speed : float= 50
var speed: float
enum facing {RIGHT, LEFT, DOWN, UP}
var facing_direction := facing.DOWN
var facing_rotation = [0, 180, 90, 270]
var facing_vector = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]

enum PlayerStates {
	NORMAL,
	SNEAKING,
	PANICKING,
	ATTACKING,
	PUSHING,
}
var state: PlayerStates = PlayerStates.NORMAL
#region Stats
const default_health: int = 3
@export var max_health : int = 5
var health : int = default_health
var pistol_ammo : int = 20
@export var max_pistol_ammo : int = 50
var invulnerable : bool = false
#endregion
#region Weapons
@export var ranged_weapon_scn : PackedScene
@export var melee_weapon_scn: PackedScene
var melee_weapon : Weapon = null
var ranged_weapon : Weapon = null
#endregion

## Set this to stop input
var paused: bool = true

func _ready():
	speed = normal_speed
	EventBus.open_terminal.connect(func(): canvas_layer.visible = false)
	EventBus.close_terminal.connect(func(): canvas_layer.visible = true)
	EventBus.use_item.connect(on_use_item)
	EventBus.pause.connect(func(): paused= true)
	EventBus.resume.connect(func(): paused= false)
	my_animated_sprite.play("idle_down_semicalm_no_weapon")
	EventBus.retry_continue.connect(on_retry_continue)
	EventBus.countdown_start.connect(func(): paused = false)

func _process(_delta):
	if paused:
		return
	if Input.is_action_just_pressed("melee_attack") and melee_weapon != null:
		melee_weapon.attack(global_position, facing_vector[facing_direction])
		state = PlayerStates.ATTACKING
	elif Input.is_action_pressed("ranged_attack") and ranged_weapon != null:
		ranged_weapon.attack(global_position, facing_vector[facing_direction])
	if Input.is_action_just_pressed("sneak") and not is_panicking():
		state = PlayerStates.SNEAKING
	if Input.is_action_just_released("sneak") and state != PlayerStates.ATTACKING:
		state = PlayerStates.NORMAL

func _physics_process(_delta: float) -> void:
	if paused:
		return
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		direction.y = 0.0
	elif Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up"):
		direction.x = 0.0
	else:
		direction = Vector2.ZERO
	match state:
		PlayerStates.SNEAKING:
			speed = sneaking_speed
		_:
			speed = normal_speed
	if direction == Vector2.RIGHT:
		my_animated_sprite.flip_h = false
		facing_direction = facing.RIGHT
	elif direction == Vector2.LEFT:
		my_animated_sprite.flip_h = true
		facing_direction = facing.LEFT
	elif direction == Vector2.DOWN:
		facing_direction = facing.DOWN
	elif direction == Vector2.UP:
		facing_direction = facing.UP
	velocity = direction * speed
	play_animation()
	move_and_slide()
	#region Push moveable boxes
	var coll_count = get_slide_collision_count()
	for i in coll_count:
		var coll = get_slide_collision(i)
		var collider = coll.get_collider()
		if collider is RigidBody2D:
			var force = speed
			state = PlayerStates.PUSHING
			collider.apply_central_impulse(-coll.get_normal()*force)
	if coll_count == 0 and not is_sneaking() and not is_attacking():
		state = PlayerStates.NORMAL
	#endregion

func take_damage(amount: int):
	health -= amount
	clamp(health, 0, max_health)
	health_changed.emit(health)
	if health <= 0:
		death()

func death():
	EventBus.player_death.emit()

# Called when the player attacks, either melee or ranged
func on_attack():
	pass

#region Items
# TODO: Having this functions to return if item is used is messy.
# Should be left to the actual function using it
func on_use_item(item: Item):
	match item.type:
		Item.Item_type.MEDIPACK:
			heal(item)
		Item.Item_type.PISTOL_AMMO:
			if ranged_weapon!= null:
				ranged_weapon.reload(item)
		Item.Item_type.SERUM:
			take_serum(item)
		Item.Item_type.CHILL_PILL:
			take_chill_pill(item)
		Item.Item_type.NOTE:
			pass
			
	if item.is_weapon():
		weapon_pickup(item)
	elif item.is_upgrade():
		weapon_upgrade(item)
	

func is_full_health() -> bool:
	return health == max_health
#
func heal(item: Item):
	if item.type != Item.Item_type.MEDIPACK:
		return
	if health < max_health:
		health = clampi(health + item.effect, 0, max_health)
		health_changed.emit(health)
		EventBus.item_used.emit(item)
	
func take_serum(item: Item):
	if item.type != Item.Item_type.SERUM:
		return
	max_health += 1
	health_changed.emit(health)
	EventBus.item_used.emit(item)

func take_chill_pill(item: Item):
	if item.type == Item.Item_type.CHILL_PILL and is_panicking():
		state = PlayerStates.NORMAL
		calm.emit()
		EventBus.item_used.emit(item)

## Populate the appropiate weapon variable when a weapon is picked up
func weapon_pickup(item : Item):
	if item.type == Item.Item_type.PISTOL:
		ranged_weapon = ranged_weapon_scn.instantiate()
		ranged_weapon.is_player = true
		add_child(ranged_weapon)
		ranged_weapon.attacking.connect(on_attack)
	else:
		melee_weapon = melee_weapon_scn.instantiate()
		melee_weapon.is_player = true
		add_child(melee_weapon)
		melee_weapon.attacking.connect(on_attack)
	equipped_weapon.emit(item)
	EventBus.item_used.emit(item)

## Function to handle weapon upgrades. Effect stores the "amount" of the upgrade.
## This may need to be changed if you can get a ranged upgrade before having the pistol
func weapon_upgrade(item: Item):
	if not item.is_upgrade():
		return
	match item.type:
		Item.Item_type.BARBED_WIRE_UPGRADE:
			if melee_weapon != null:
				melee_weapon.upgrade(item)
		_:
			if ranged_weapon != null:
				ranged_weapon.upgrade(item)
#endregion
#region animation
func play_animation():
	var anim_name: String = ""
	match state:
		PlayerStates.NORMAL, PlayerStates.SNEAKING:
			if velocity:
				anim_name = match_movement_animation()
			else:
				anim_name = match_idle()
		PlayerStates.ATTACKING:
			anim_name = smashing_animation()
		PlayerStates.PUSHING:
			anim_name = pushing_animation()
	my_animated_sprite.play(anim_name)

##Match the animation based on the movement direction
func match_movement_animation()->String:
	var animation_name: String = ""
	match state:
		PlayerStates.NORMAL:
			animation_name = normal_animation()
		PlayerStates.SNEAKING:
			animation_name = sneak_animation()
	return animation_name

func smashing_animation() -> String:
	if not my_animated_sprite.animation_finished.is_connected(attack_anim_end):
		my_animated_sprite.animation_finished.connect(attack_anim_end)
	var anim_name = "smack_w_cricket_bat_" + check_facing_direction()
	return anim_name

func attack_anim_end():
	state = PlayerStates.NORMAL
	my_animated_sprite.animation_finished.disconnect(attack_anim_end)

func sneak_animation() -> String:
	var anim_name = "sneak_" + check_facing_direction() + "_" + weapon_name()
	return anim_name

func normal_animation() -> String:
	var anim_name = "walk_" + check_facing_direction() + "_semicalm_" + weapon_name()
	return anim_name
	
func pushing_animation() -> String:
	var anim_name = "push_" + check_facing_direction()
	return anim_name

func weapon_name() -> String:
	if ranged_weapon != null:
		return "pistol"
	elif melee_weapon != null:
		return "cricket_bat"
	return"no_weapon"

func check_facing_direction() -> String:
	var dir = ""
	match facing_direction:
		facing.LEFT:
			dir += "side"
			my_animated_sprite.flip_h = true
		facing.UP:
			dir += "up"
		facing.DOWN:
			dir += "down"
		facing.RIGHT:
			dir += "side"
			my_animated_sprite.flip_h = false
	return dir

##Match the animation based on the idle direction		
func match_idle() -> String:
	var animation_name = "idle_" + check_facing_direction()
	animation_name += "_semicalm_" + weapon_name()
	if state == PlayerStates.ATTACKING:
		animation_name = smashing_animation()
	return animation_name
#endregion	

func on_panic():
	state = PlayerStates.PANICKING

#region Helper functions
func is_sneaking() -> bool:
	return state == PlayerStates.SNEAKING

func is_attacking() -> bool:
	return state == PlayerStates.ATTACKING

# NOTE: Return always false since panicking is on hold for now
func is_panicking() -> bool:
	return false
	#return state == PlayerStates.PANICKING
#endregion

func on_retry_continue():
	health = default_health
	health_changed.emit(health)
