extends CharacterBody2D
class_name Player


signal on_panic
signal calm

@onready var my_animation_player = $AnimationPlayer
@onready var my_sprite := $Sprite2D

#movement variables
var direction : Vector2
@export var speed : float = 100
enum facing {RIGHT, LEFT, DOWN, UP}
var facing_direction := facing.DOWN


var is_panicking := false 
var is_sneaking := false

var inventory : Array[Item] = []

func _ready():
	my_animation_player.play("idle_down")
	EventBus.pick_item.connect(on_item_pickup)
	

func _physics_process(delta: float) -> void:

	velocity = direction * speed
	if velocity : match_movemnt_animation()
	else: match_idle()
	
	move_and_slide()





func _input(event: InputEvent) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	

	



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

#region inventory
func on_item_pickup(item: Item):
	inventory.append(item)
#endregion
