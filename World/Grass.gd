extends Node2D

func scatter():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	# Instantiates the grass effect scene
	var grassEffect = GrassEffect.instance()
	
	# Get the world scene from the scene tree
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	
	# Set the grass effect scene in the current grass position
	grassEffect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	scatter()
	queue_free()
