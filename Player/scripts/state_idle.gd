class_name State_Idle extends State

@export var friction: float = 500.0
@onready var animation_tree: AnimationTree = $"../../AnimationTree"
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var walk: State_Walk = $"../Walk"

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(_delta: float) -> State:
	
	if player.dir != Vector2.ZERO:
		return walk
	
	animation_state.travel("Idle");
	player.velocity = player.velocity.move_toward(Vector2.ZERO, friction * _delta);
	return null

func physics(_delta: float) -> State:
	return null

func handleInput(_event: InputEvent) -> State:
	return null
