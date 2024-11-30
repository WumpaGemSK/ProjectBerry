extends Node2D

signal animation_finished

@onready var path_2d: Path2D = $Path2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var line_2d: Line2D = %Line2D

@export var tween_speed : float = 10

var anim: bool = false

func _process(delta: float) -> void:
	if anim:
		# Point spam but it shouldn't matter
		var point = to_global(path_follow_2d.position)
		line_2d.add_point(point)

func render_line():
	anim = true
	var tween = create_tween()
	# If the final value is 1, it add one extra point that goes back to the start of the path
	# With 0.99 it doesn't happen
	tween.tween_property(path_follow_2d, "progress_ratio", 0.99, tween_speed)
	tween.finished.connect(on_tween_finished)

func on_tween_finished():
	anim = false
	animation_finished.emit()
