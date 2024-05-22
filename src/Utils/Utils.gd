extends Node

# TODO: Create a utils file and move this function to it
func get_collision_shape_shape(collision_shape: CollisionShape2D):
	return collision_shape.get_shape().size

# TODO: Create a utils file and move this function to it
func get_collision_shape_short_side(collision_shape: CollisionShape2D) -> float:
	var shape = get_collision_shape_shape(collision_shape)
	print(shape)
	return min(shape[0], shape[1])

# TODO: Create a utils file and move this function to it
func get_collision_shape_long_side(collision_shape) -> float:
	var shape = get_collision_shape_shape(collision_shape)
	return max(shape[0], shape[1])
