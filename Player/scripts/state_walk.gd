class_name State_Walk extends State

@export var speed: float = 100.0
@export var accel: float = 1100.0

@onready var idle: State_Idle = $StateMachine/Idle
@onready var animation_tree: AnimationTree = $"../../AnimationTree"
@onready var animation_state = animation_tree.get("parameters/playback")

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(_delta: float) -> State:
	if player.dir == Vector2.ZERO:
		return idle

	animation_tree.set("parameters/Idle/blend_position", player.dir)
	animation_tree.set("parameters/Walk/blend_position", player.dir)
	animation_state.travel("Walk");
	
	player.velocity = player.velocity.move_toward(player.dir * speed, accel * _delta)
	
	
	return null

func physics(_delta: float) -> State:
	return null

func handleInput(_event: InputEvent) -> State:
	return null
