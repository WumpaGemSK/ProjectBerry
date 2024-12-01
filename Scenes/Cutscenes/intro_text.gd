extends Control

var page_number : int

func _ready() -> void:
	 
	page_number = 1
	
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		pass

func update_page() -> void:
	pass
