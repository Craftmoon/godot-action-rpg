extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
enum {
	IDLE,
	WANDER,
	CHASE
}
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

func _ready():
	state =	pick_random_state([IDLE, WANDER])
	sprite.frame = randi() % 5

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderController.get_time_left() == 0:
				randomize_movement_state()
		WANDER:
			if wanderController.get_time_left() == 0:
				randomize_movement_state()
				
			accelerate_towards_point(wanderController.target_position, delta)
			
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				randomize_movement_state()
				
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
				
	sprite.flip_h = velocity.x < 0
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func randomize_movement_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,3))

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED , ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func _on_Hurtbox_area_entered(area):
	# This area that this signal receives is the area that entered the hurtbox
	# that's why you have access to knocback_vector from the sword hitbox
	
	# In defensive programming this would probably have a chack of wether the
	# area has the knockbar_vector property or not
	knockback = area.knockback_vector * 80
	stats.health -= area.damage
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.3)
	

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

# Player chase functionality code
func _on_PlayerDetectionZone_body_entered(_body):
	state = CHASE

func _on_PlayerDetectionZone_body_exited(_body):
	state = IDLE


func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")
