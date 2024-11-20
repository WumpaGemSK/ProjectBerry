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

#region Stats
var is_panicking := false
var is_sneaking := false
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
	panic.connect(on_panic)

func _process(_delta):
	if Input.is_action_just_pressed("melee_attack") and melee_weapon != null:
		melee_weapon.attack(global_position, facing_vector[facing_direction])
	elif Input.is_action_pressed("ranged_attack") and ranged_weapon != null:
		ranged_weapon.attack(global_position, facing_vector[facing_direction])
	
	if Input.is_action_just_pressed("sneak") and not is_panicking:
		is_sneaking = true
		speed = sneaking_speed
	if Input.is_action_just_released("sneak"):
		is_sneaking = false
		speed = normal_speed

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
	var item_used : bool = false
	if item.is_weapon():
		item_used = weapon_pickup(item)
	elif item.is_upgrade():
		item_used = weapon_upgrade(item)
	elif item.is_consumable():
		item_used = consume_item(item)
	
	if item_used:
		EventBus.item_used.emit(item)

func consume_item(item: Item) -> bool:
	var effect = item.effect
	match item.type:
		Item.Item_type.MEDIPACK:
			return heal(effect)
		Item.Item_type.PISTOL_AMMO:
			if ranged_weapon!= null:
				return ranged_weapon.reload(effect)
		Item.Item_type.SERUM:
			return take_serum()
		Item.Item_type.CHILL_PILL:
			return take_chill_pill()
	return false

func is_full_health() -> bool:
	return health == max_health
#
func heal(amount: int) -> bool:
	if health < max_health:
		health = clampi(health + amount, 0, max_health)
		health_changed.emit(health)
		return true
	return false
	
func take_serum() -> bool:
	max_health += 1
	health_changed.emit(health)
	return true

func take_chill_pill() -> bool:
	if is_panicking:
		is_panicking = false
		calm.emit()
		return true
	return false

## Populate the appropiate weapon variable when a weapon is picked up
func weapon_pickup(item : Item) -> bool:
	if not item.is_weapon():
		return false
	if item.type == Item.Item_type.PISTOL:
		ranged_weapon = ranged_weapon_scn.instantiate()
		add_child(ranged_weapon)
		ranged_weapon.attacking.connect(on_attack)
	else:
		melee_weapon = melee_weapon_scn.instanciate()
		add_child(melee_weapon)
		melee_weapon.attacking.connect(on_attack)
	equipped_weapon.emit(item)
	return true

## Function to handle weapon upgrades. Effect stores the "amount" of the upgrade.
## This may need to be changed if you can get a ranged upgrade before having the pistol
func weapon_upgrade(item: Item) -> bool:
	if not item.is_upgrade():
		return false
	match item.type:
		Item.Item_type.BARBED_WIRE_UPGRADE:
			if melee_weapon != null:
				melee_weapon.upgrade(item)
		_:
			if ranged_weapon != null:
				ranged_weapon.upgrade(item)
		
	return false
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
	is_panicking = true
