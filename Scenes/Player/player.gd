extends CharacterBody2D
class_name Player

signal on_panic
signal calm
signal pistol_ammo_update(new_amount : int)
signal pistol_ammo_upgrade(new_max : int)
signal equipped_weapon(weapon: Item)
signal health_changed(new_health: int)

@onready var my_animated_sprite := $AnimatedSprite2D

#movement variables
var direction : Vector2
@export var speed : float = 100
enum facing {RIGHT, LEFT, DOWN, UP}
var facing_direction := facing.DOWN

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
var melee_weapon : Item = null
var ranged_weapon : Item = null
#endregion

func _ready():
	EventBus.use_item.connect(on_use_item)
	my_animated_sprite.play("idle_down_semicalm_no_weapon")

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

#region Items
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
			return refill_ammo(effect)
		Item.Item_type.SERUM:
			return take_serum()
		Item.Item_type.CHILL_PILL:
			return take_chill_pill()
	return false

func is_full_health() -> bool:
	return health == max_health

func heal(amount: int) -> bool:
	if health < max_health:
		health = clampi(health + amount, 0, max_health)
		health_changed.emit(health)
		return true
	return false
	
func refill_ammo(amount : int) -> bool:
	if pistol_ammo < max_pistol_ammo:
		pistol_ammo = clampi(pistol_ammo + amount, 0, max_pistol_ammo)
		pistol_ammo_update.emit(pistol_ammo)
		return true
	return false
	
func take_serum() -> bool:
	max_health += 1
	health_changed.emit(health)
	return true

func take_chill_pill() -> bool:
	
	if is_panicking:
		is_panicking = false
		return true
		
	return false

## Populate the appropiate weapon variable when a weapon is picked up
func weapon_pickup(item : Item) -> bool:
	if not item.is_weapon():
		return false
	if item.type == Item.Item_type.PISTOL:
		ranged_weapon = item
	else:
		melee_weapon = item
	equipped_weapon.emit(item)
	return true

## Function to handle weapon upgrades. Effect stores the "amount" of the upgrade.
## This may need to be changed if you can get a ranged upgrade before having the pistol
func weapon_upgrade(item: Item) -> bool:
	if not item.is_upgrade():
		return false
	match item.type:
		Item.Item_type.PISTOL_DAMAGE_UPGRADE:
			if ranged_weapon != null:
				ranged_weapon.effect += item.effect
				return true
		Item.Item_type.PISTOL_FIRE_RATE_UPGRADE:
			if ranged_weapon != null:
				# TODO: Update to when fire rate is implemented
				return true
		Item.Item_type.MAX_PISTOL_AMMO_UPGRADE:
			max_pistol_ammo += item.effect
			pistol_ammo_upgrade.emit(max_pistol_ammo)
			return true
		Item.Item_type.BARBED_WIRE_UPGRADE:
			if melee_weapon != null:
				melee_weapon.effect *= item.effect
				return true
	return false
#endregion
#region animation
##Match the animation based on the movement direction
func match_movement_animation():
	
	if direction == Vector2.RIGHT:
		my_animated_sprite.play("walk_side_semicalm_no_weapon")
		my_animated_sprite.flip_h = false
		facing_direction = facing.RIGHT
		print("walk right")
		
	elif direction == Vector2.LEFT:
		my_animated_sprite.play("walk_side_semicalm_no_weapon")
		my_animated_sprite.flip_h = true
		facing_direction = facing.LEFT	
		print("walk left")
		
	elif direction == Vector2.DOWN:
		my_animated_sprite.play("walk_down_semicalm_no_weapon")
		facing_direction = facing.DOWN	
		print("walk down")
		
	elif direction == Vector2.UP:
		my_animated_sprite.play("walk_up_semicalm_no_weapon")
		facing_direction = facing.UP
		print("walk up")

		
##Match the animation based on the idle direction		
func match_idle():
	
	if facing_direction == facing.RIGHT:
		my_animated_sprite.play("idle_side_semicalm_no_weapon")
		my_animated_sprite.flip_h = false
		print("idle right")
		
	elif facing_direction == facing.LEFT:
		my_animated_sprite.play("idle_side_semicalm_no_weapon")
		my_animated_sprite.flip_h = true
		print("idle left")
		
	elif facing_direction == facing.DOWN:
		my_animated_sprite.play("idle_down_semicalm_no_weapon")
		print("idle down")
		
	elif facing_direction == facing.UP:
		my_animated_sprite.play("idle_up_semicalm_no_weapon")
		print("idle up")
		
		
#endregion	
