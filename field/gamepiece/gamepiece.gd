@tool

@icon("res://assets/editor/icons/Gamepiece.svg")
class_name Gamepiece extends Node2D

@export var tile_map_layer: TileMapLayer:
	set(value):
		tile_map_layer = value
		update_configuration_warnings()

@export var sprite: AnimatedSprite2D:
	set(value):
		sprite = value
		update_configuration_warnings()
		
@export var move_speed: float = 1:
	set(value):
		move_speed = value

var astar_grid: AStarGrid2D
var curr_path: Array[Vector2i]
var target_position: Vector2
var is_moving: bool
var dir: Vector2

func _ready() -> void:
	update_configuration_warnings()
	
	## Check for tilemap
	if not Engine.is_editor_hint():
		assert(tile_map_layer, "Gamepiece '%s' must have a TileMapLayer reference to function!" % name)
		assert(sprite, "Gamepiece '%s' must have a AnimatedSprite2D reference to function!" % name)
	
	## Setup grid
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map_layer.get_used_rect()
	astar_grid.cell_size = Vector2i(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	var region_size = astar_grid.region.size
	var region_pos = astar_grid.region.position
	
	for x in region_size.x:
		for y in region_size.y:
			var tile_pos = Vector2i(
				x + region_pos.x, 
				y + region_pos.y
			)
			var tile_data: TileData = tile_map_layer.get_cell_tile_data(tile_pos)
			if tile_data == null or tile_data.get_custom_data("walkable") == false:
				astar_grid.set_point_solid(tile_pos)
				
			

func _physics_process(_delta: float) -> void:
	if curr_path.is_empty():
		return
	
	if is_moving == false:
		target_position = tile_map_layer.map_to_local(curr_path.front())
		is_moving = true
	
	dir = (target_position - global_position).normalized()
	global_position = global_position.move_toward(target_position, move_speed)
	
	if global_position == target_position:
		curr_path.pop_front()
		
		if curr_path.is_empty() == false:
			target_position = tile_map_layer.map_to_local(curr_path.front())
		else:
			is_moving = false

func get_target_tile_from_dir(direction: Vector2) -> Vector2i:
	var curr_tile: Vector2i = tile_map_layer.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(curr_tile.x + direction.x as int, curr_tile.y + direction.y as int)
	if is_moving:
		return curr_tile
	else:
		return target_tile

func travel_to_tile(target_tile: Vector2i) -> void:
	
	var gamepieces = get_tree().get_nodes_in_group("gamepieces")
	var occupied_positions: Array[Vector2i] = []
	
	for gamepiece in gamepieces:
		if gamepiece == self:
			continue
		
		occupied_positions.append(tile_map_layer.local_to_map(gamepiece.global_position))
		
	for occupied_position: Vector2i in occupied_positions:
		astar_grid.set_point_solid(occupied_position)
		
	var path
	
	if is_moving:
		path = astar_grid.get_id_path(
			tile_map_layer.local_to_map(target_position),
			target_tile
	)
	else:
		path = astar_grid.get_id_path(
			tile_map_layer.local_to_map(global_position),
			target_tile
		).slice(1)
	
	if path.is_empty() == false:
		curr_path = path
	
	for occupied_position: Vector2i in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	
	
	
