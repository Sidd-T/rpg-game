class_name Player extends CharacterBody2D

var speed: float = 100.0;
var accel: float = 1100.0
var friction: float = 500.0
var cardinal_dir: Vector2 = Vector2.DOWN


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var animationTree = $AnimationTree;
@onready var animationState = animationTree.get("parameters/playback")
@onready var state_machine: PlayerStateMachine = $StateMachine


func _ready():
	state_machine.initialize(self)
	motion_mode = MOTION_MODE_FLOATING;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir: Vector2 = Vector2.ZERO
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	dir = dir.normalized()
	
	#if dir != Vector2.ZERO:
		#animationTree.set("parameters/Idle/blend_position", dir);
		#animationTree.set("parameters/Walk/blend_position", dir);
		#animationState.travel("Walk");
		#
		#velocity = velocity.move_toward(dir * speed, accel * delta);
	#else:
		#animationState.travel("Idle");
		#velocity = velocity.move_toward(Vector2.ZERO, friction * delta);

func _physics_process(_delta):
	move_and_slide()
