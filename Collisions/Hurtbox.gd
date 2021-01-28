extends Area2D

onready var HitEffect = preload("res://Effects/HitEffect.tscn")
onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

# The way the invincibility is implemented here isn't really "invincibility"
# because you're only immune to sequential attacks of the same bat. If another
# bat comes and attack you in the 0.5 sec invincibility time, it will damage
# you the same. This is just to prevent a single bat from not hitting you when
# it gets inside your area (not triggering on_area_entered nor repeatedly 
# hitting you once it's inside you area without a attak rate.
# The best solution to this would be an attack rate in the enemy
var invincible = false setget set_invincible

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var hitEffect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(hitEffect)
	hitEffect.global_position = global_position

func _on_Timer_timeout():
	# Self needs to be called here because you want to trigger the setter function
	self.invincible = false

func _on_Hurtbox_invincibility_ended():
	collisionShape.set_deferred("disabled", false)

func _on_Hurtbox_invincibility_started():
	collisionShape.set_deferred("disabled", true)
