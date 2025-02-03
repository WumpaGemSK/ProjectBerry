extends Node2D

var astar_grid : AStarGrid2D
var tile_map_layer : TileMapLayer

func init():
	if astar_grid == null:
		astar_grid = AStarGrid2D.new()
	tile_map_layer = get_tree().get_first_node_in_group("Navigation")
	if not tile_map_layer:
		return
	astar_grid.cell_size = tile_map_layer.tile_set.tile_size
	astar_grid.region = tile_map_layer.get_used_rect()
	astar_grid.cell_shape = AStarGrid2D.CELL_SHAPE_SQUARE
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.offset = astar_grid.cell_size/2
	astar_grid.update()
	for cell_pos in tile_map_layer.get_used_cells():
		var tile_data = tile_map_layer.get_cell_tile_data(cell_pos)
		if tile_data == null or not tile_data.get_custom_data("Walkable"):
			astar_grid.set_point_solid(cell_pos, true)

func _ready():
	init()

func get_valid_path(current_pos: Vector2, target_pos: Vector2) -> PackedVector2Array:
	var curr = tile_map_layer.local_to_map(to_local(current_pos))
	var target = tile_map_layer.local_to_map(to_local(target_pos))
	var tmp = astar_grid.get_point_path(curr, target)
	if tmp.is_empty():
		return []
	tmp.remove_at(0)
	
	var path :PackedVector2Array = []
	for p in tmp:
		path.append(to_global(p))
	return path
