extends Node2D

func _process(delta):
	if(Input.is_action_just_pressed("attack")):
		# Load the grass effect scene
		var GrassEffect = load("res://Effects/GrassEffect.tscn")
		
		# Instantiates the grass effect scene
		var grassEffect = GrassEffect.instance()
		
		# Get the world scene from the scene tree
		var world = get_tree().current_scene
		world.add_child(grassEffect)
		
		# Set the grass effect scene in the current grass position
		grassEffect.global_position = global_position
		queue_free()
