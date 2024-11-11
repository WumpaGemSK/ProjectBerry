extends Item
class_name PickableItem

@onready var pick_ui = %Pick_UI
@onready var icon = %Icon

var player_in_range = false

func _ready():
	icon.texture = texture_icon

func _process(_delta):
	if Input.is_action_pressed("interact") and player_in_range:
		var item = Item.copy(self)
		EventBus.pick_item.emit(item)
		queue_free()
	
	if player_in_range:
		pick_ui.visible = true
	else:
		pick_ui.visible = false
		

func _on_area_2d_body_entered(body):
	if body is Player:
		player_in_range = true


func _on_area_2d_body_exited(body):
	if body is Player:
		player_in_range = false
