extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

# This isn't a good way to do this. Maybe refactor this in the future 
# before going to another project
func get_push_vector():
	var push_vector = Vector2.ZERO
	if is_colliding():
		var areas = get_overlapping_areas()
		var area = areas[0]
		push_vector = area.global_position.direction_to(global_position)
	return push_vector
