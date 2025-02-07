extends Node2D

signal new_path_req

var speed : float : 
	set(value):
		speed = value

var path : PackedVector2Array = [] :
	set(value):
		path = value

func step(current_pos: Vector2) -> Vector2:
	if path.is_empty():
		new_path_req.emit()
		return Vector2(0,0)
	var target = path[0]
	var vel : Vector2
	vel = current_pos.direction_to(path[0])*speed
	if current_pos.distance_to(target) < .5:
		path.remove_at(0)
	return vel
