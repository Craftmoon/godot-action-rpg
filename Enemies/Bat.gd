extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

var knockback = Vector2.ZERO
var life = 3

onready var stats = $Stats

func _ready():
	print(stats.max_health)
	print(stats.health)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	# This area that this signal receives is the area that entered the hurtbox
	# that's why you have access to knocback_vector from the sword hitbox
	
	# In defensive programming this would probably have a chack of wether the
	# area has the knockbar_vector property or not
	knockback = area.knockback_vector * 80
	stats.health -= area.damage

func _on_Hitbox_area_entered(area):
	pass

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
