class_name Player extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animationTree = $AnimationTree;
@onready var animationState = animationTree.get("parameters/playback")
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var is_moving: bool = false
@onready var tile_map_layer: TileMapLayer = $"../Tiles/TileMapLayer"

func _ready():
	pass

func _physics_process(_delta: float) -> void:
	if is_moving == false:
		return
	if global_position == sprite.global_position:
		is_moving = false
		return
	
	sprite.global_position = sprite.global_position.move_toward(global_position, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_moving:
		return
	
	if Input.is_action_pressed("up"):
		move(Vector2.UP)
	elif Input.is_action_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_pressed("right"):
		move(Vector2.RIGHT)
	else:
		sprite.frame = 0
		animationState.travel("Idle");

func move(dir: Vector2) -> void:
	
	animationTree.set("parameters/Idle/blend_position", dir);
	animationTree.set("parameters/Walk/blend_position", dir);
	
	# Get curr tile vector2i
	var curr_tile: Vector2i = tile_map_layer.local_to_map(global_position)
	# Get target tile vector2i
	var target_tile: Vector2i = Vector2i(curr_tile.x + dir.x as int, curr_tile.y + dir.y as int)
	# Get custom data layer from target tile
	var tile_data: TileData = tile_map_layer.get_cell_tile_data(target_tile)
	if tile_data.get_custom_data("walkable") == false:
		return 
	# Get raycast collisions
	ray_cast_2d.target_position = (dir * 16)
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		animationState.travel("Idle")
		return
	
	# Move Player
	is_moving = true
	
	animationState.travel("Walk")
	global_position = tile_map_layer.map_to_local(target_tile)
	sprite.global_position = tile_map_layer.map_to_local(curr_tile)
	
