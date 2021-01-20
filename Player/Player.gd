extends KinematicBody2D

const ACCELERATION = 50
const MAX_SPEED = 150
const FRICTION = 25
var velocity = Vector2.ZERO

func _physics_process(delta):
	# everything that  changes overtime you need to multiply it by delta
	# so it doesn't vary on the users' framerate
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta 
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) 
	print (velocity)
	# It is being multiplied by delta so the frame rate doesn't affect the velocity
	move_and_collide(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
