extends CharacterBody2D
class_name Player

signal on_panic
signal calm

@onready var my_animated_sprite := $AnimatedSprite2D

#movement variables
var direction : Vector2
@export var speed : float = 100
enum facing {RIGHT, LEFT, DOWN, UP}
var facing_direction := facing.DOWN

var is_panicking := false
var is_sneaking := false

func _ready():
	
	my_animated_sprite.play("idle_down_semicalm_no_weapon")

func _physics_process(delta: float) -> void:

	velocity = direction * speed
	
	if velocity:
		match_movement_animation()
	else:
		match_idle()
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

func is_full_health() -> bool:
	
	return false

func heal(amount: int) -> bool:
	
	return false
	
func refill_ammo(amount : int) -> bool:
	
	return false
	
func take_serum() -> bool:
	
	return false

func take_chill_pill() -> bool:
	
	if is_panicking:
		is_panicking = false
		return true
		
	return false

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
		my_animated_sprite.play("walk_down_semicalm_no_weapon")
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
