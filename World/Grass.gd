extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func scatter():
	# Instantiates the grass effect scene
	var grassEffect = GrassEffect.instance()
	
	get_parent().add_child(grassEffect)
	
	# Set the grass effect scene in the current grass position
	grassEffect.global_position = global_position

func _on_Hurtbox_area_entered(_area):
	scatter()
	queue_free()
