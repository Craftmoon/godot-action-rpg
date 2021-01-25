extends KinematicBody2D

export var ACCELERATION = 800
export var MAX_SPEED = 100
export var FRICTION = 700
export var ROLL_SPEED = 150

enum {
	MOVE,
	ATTACK,
	ROLL
}

var velocity = Vector2.ZERO
var state = MOVE
var starting_vector = Vector2.LEFT
var roll_vector = starting_vector	
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox

func _ready():
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = starting_vector

# _physics_process has a constant delta, and actually waits for the physics to 
# be done before running, while _process runs as fast as possible.
# So if you need stuff from physics, like position or etc it's better to use
# _physics_process because with only _process you might get a position before 
# it's actually updated.
func _physics_process(delta):
	# everything that  changes overtime you need to multiply it by delta
	# so it doesn't vary on the users' framerate
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector

func move_state(delta):
	var input_vector = get_input_vector()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	# Move and slide multiplies by delta by default
	# Also, just receiving the move_and_slide return makes some weird behavior not happen anymore when coliding
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func move():
	velocity = move_and_slide(velocity)

func attack_state(delta):
	animationState.travel("Attack")
	velocity = Vector2.ZERO

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")	
	move()

func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	velocity = velocity - velocity*0.5
	state = MOVE

func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	# Try disabling the player's hitbox for a 0.5 seconds when they get hit
	# Or try creating a attack rate in the enemies so they can only attack once per 0.5 sec (better solution)
