extends KinematicBody2D

const ACCELERATION = 800
const MAX_SPEED = 100
const FRICTION = 700

enum {
	MOVE,
	ATTACK,
	ROLL
}

enum{
	DOWN,
	LEFT,
	RIGHT,
	UP
}

var velocity = Vector2.ZERO
var state = MOVE
var facingDirection = LEFT

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

# _physics_process has a constant delta, and actually waits for the physics to 
# be done before running, while _process runs as fast as possible.
# So if you need stuff from physics, like position or etc it's better to use
# _physics_process because with only _process you might get a position before 
# it's actually updated.
func _process(delta):
	# everything that  changes overtime you need to multiply it by delta
	# so it doesn't vary on the users' framerate
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	#print(velocity)
	# Move and slide multiplies by delta by default
	# Also, just receiving the move_and_slide return makes some weird behavior not happen anymore when coliding
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func attack_state(delta):
	animationState.travel("Attack")
	velocity = Vector2.ZERO
	print("Attack!")

func roll_state(delta):
	animationState.travel("Roll")
	# Need to fix this velocity to be a constant and to use the facingDirection
	# So the player rolls even if he was previosly not moving
	move_and_slide(velocity + velocity*0.5)
	print("Roll!")

func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	velocity = velocity - velocity*0.5
	state = MOVE
