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
var state = CHASE
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision

func _ready():
	print(stats.max_health)
	print(stats.health)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			print("idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		WANDER:
			print("wander")
		CHASE:
			print("chase")
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED , ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func _on_Hurtbox_area_entered(area):
	# This area that this signal receives is the area that entered the hurtbox
	# that's why you have access to knocback_vector from the sword hitbox
	
	# In defensive programming this would probably have a chack of wether the
	# area has the knockbar_vector property or not
	knockback = area.knockback_vector * 80
	stats.health -= area.damage
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

# Player chase functionality code
func _on_PlayerDetectionZone_body_entered(body):
	state = CHASE

func _on_PlayerDetectionZone_body_exited(body):
	state = IDLE
