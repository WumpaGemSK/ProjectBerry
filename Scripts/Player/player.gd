extends CharacterBody2D
class_name Player

signal panic
signal calm

signal equipped_weapon(weapon: Item)
signal health_changed(new_health: int)

@onready var my_animated_sprite := $AnimatedSprite2D

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
}
var state: PlayerStates = PlayerStates.NORMAL
#region Stats
@export var max_health : int = 5
var health : int = max_health
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

func _ready():
	speed = normal_speed
	EventBus.use_item.connect(on_use_item)
	my_animated_sprite.play("idle_down_semicalm_no_weapon")
	#panic.connect(on_panic)

func _process(_delta):
	if Input.is_action_just_pressed("melee_attack") and melee_weapon != null:
		melee_weapon.attack(global_position, facing_vector[facing_direction])
	elif Input.is_action_pressed("ranged_attack") and ranged_weapon != null:
		ranged_weapon.attack(global_position, facing_vector[facing_direction])
	
	if Input.is_action_just_pressed("sneak") and not is_panicking():
		state = PlayerStates.SNEAKING
	if Input.is_action_just_released("sneak") and not is_panicking():
		state = PlayerStates.NORMAL

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("move_down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("move_up"):
		direction = Vector2.UP
	else:
		direction = Vector2.ZERO
	match state:
		PlayerStates.SNEAKING:
			speed = sneaking_speed
		_:
			speed = normal_speed
	velocity = direction * speed
	if velocity:
		match_movement_animation()
	else:
		match_idle()
	move_and_slide()

func take_damage(amount: int):
	health -= amount
	health_changed.emit(health)
	if health <= 0:
		death()

func death():
	print("death")
	pass

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
		melee_weapon = melee_weapon_scn.instanciate()
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
##Match the animation based on the movement direction
func match_movement_animation():
	
	if direction == Vector2.RIGHT:
		my_animated_sprite.play("walk_side_semicalm_no_weapon")
		my_animated_sprite.flip_h = false
		facing_direction = facing.RIGHT
		
	elif direction == Vector2.LEFT:
		my_animated_sprite.play("walk_side_semicalm_no_weapon")
		my_animated_sprite.flip_h = true
		facing_direction = facing.LEFT	
		
	elif direction == Vector2.DOWN:
		my_animated_sprite.play("walk_down_semicalm_no_weapon")
		facing_direction = facing.DOWN	
		
	elif direction == Vector2.UP:
		my_animated_sprite.play("walk_up_semicalm_no_weapon")
		facing_direction = facing.UP

		
##Match the animation based on the idle direction		
func match_idle():
	
	if facing_direction == facing.RIGHT:
		my_animated_sprite.play("idle_side_semicalm_no_weapon")
		my_animated_sprite.flip_h = false
		
	elif facing_direction == facing.LEFT:
		my_animated_sprite.play("idle_side_semicalm_no_weapon")
		my_animated_sprite.flip_h = true
		
	elif facing_direction == facing.DOWN:
		my_animated_sprite.play("idle_down_semicalm_no_weapon")
		
	elif facing_direction == facing.UP:
		my_animated_sprite.play("idle_up_semicalm_no_weapon")
		
		
#endregion	

func on_panic():
	state = PlayerStates.PANICKING

#region Helper functions
func is_sneaking() -> bool:
	return state == PlayerStates.SNEAKING

# NOTE: Return always false since panicking is on hold for now
func is_panicking() -> bool:
	return false
	#return state == PlayerStates.PANICKING
#endregion
