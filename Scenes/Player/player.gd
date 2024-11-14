extends CharacterBody2D
class_name Player

signal on_panic
signal calm
signal pistol_ammo_update(new_amount : int)
signal pistol_ammo_upgrade(new_max : int)
signal equipped_weapon(weapon: Item)
signal health_changed(new_health: int)

@onready var my_animation_player = $AnimationPlayer
@onready var my_sprite := $Sprite2D

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
	my_animation_player.play("idle_down")
	

func _physics_process(delta: float) -> void:
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
		match_movemnt_animation()
	else:
		match_idle()
	move_and_slide()

#region Items
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
func match_movemnt_animation():
	if direction == Vector2.RIGHT:
		my_animation_player.play("walk_right")
		my_sprite.flip_h = false
		facing_direction = facing.RIGHT
	elif direction == Vector2.LEFT:
		my_animation_player.play("walk_right")
		my_sprite.flip_h = true
		facing_direction = facing.LEFT	
	elif direction == Vector2.DOWN:
		my_animation_player.play("walk_down")
		facing_direction = facing.DOWN	
	elif direction == Vector2.UP:
		my_animation_player.play("walk_up")
		facing_direction = facing.UP

		
##Match the animation based on the idle direction		
func match_idle():
	if facing_direction == facing.RIGHT:
		my_animation_player.play("idle_right")
		my_sprite.flip_h = false
	elif facing_direction == facing.LEFT:
		my_animation_player.play("idle_right")
		my_sprite.flip_h = true
	elif facing_direction == facing.DOWN:
		my_animation_player.play("idle_down")
	elif facing_direction == facing.UP:
		my_animation_player.play("idle_up")
		
		
#endregion	
