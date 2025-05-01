extends CanvasLayer

signal on_transition_finished

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	
	self.hide()
	animation_player.animation_finished.connect(_on_animation_finished)

func transition():
	
	animation_player.play("fade_to_black")

func transition_white():
	
	animation_player.play("fade_to_white")

func _on_animation_finished(anim_name):
	
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		animation_player.play("fade_from_black")
	elif anim_name == "fade_to_white":
		on_transition_finished.emit()
		animation_player.play("fade_from_white")
