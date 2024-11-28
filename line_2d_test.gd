extends Node2D

@onready var path_2d: Path2D = $Path2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var line_2d: Line2D = $Line2D
@onready var marker_2d: Marker2D = $Path2D/PathFollow2D/Marker2D

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		
		print("DRAW!!")
		
		var tween = create_tween()
		tween.tween_property(path_follow_2d, "progress_ratio", 1, 10)
		
		line_2d.add_point(path_follow_2d.global_position)
