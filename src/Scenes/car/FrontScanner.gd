extends Area2D

@onready var collision_shape = $BodyCollisionShape

var bodies_in_range: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_front_scanner_length():
	#var front_scanner_collision_shape = get_node(StringConsts.body_collision_shape_str)
	return Utils.get_collision_shape_long_side(collision_shape)

func get_dist_to_body(body, car_shape, car_position) -> float:
	var body_collision_shape = body.get_node(StringConsts.body_collision_shape_str) #TODO: Every potential body needs to have a CollisionShape2D
	var body_length = max(body_collision_shape.shape.size[0], body_collision_shape.shape.size[1])
	var car_length = Utils.get_collision_shape_long_side(car_shape.get_node(StringConsts.body_collision_shape_str))
	# TODO: Fix to consider angle between the bodies
	var dist = (body.position - car_position).length() - body_length/2 - car_length/2
	return dist

# TODO: Refactor this mess of a function
func get_closest_body_and_range(car_shape, car_position) -> Dictionary:
	var min_dist_body = null
	var min_dist = get_front_scanner_length()
	
	for body in bodies_in_range:
		if not body.is_blocking_traffic:
			continue
		var dist = get_dist_to_body(body, car_shape, car_position)
		if dist < min_dist:
			min_dist = dist
			min_dist_body = body

	return {StringConsts.MIN_DIST: min_dist, StringConsts.MIN_DIST_BODY: min_dist_body}

func update_front_scanner_shape(car_velocity: Vector2) -> void:
	var front_scanner_width = Utils.get_collision_shape_short_side(collision_shape)
	var front_scanner_length = FrontScannerConsts.base_search_length + FrontScannerConsts.velocity_factor * car_velocity.length()
	collision_shape.shape.set_size(Vector2(front_scanner_width, front_scanner_length))

func update_front_scanner_position(car_shape):
	var car_shape_collision_shape = car_shape.get_node(StringConsts.body_collision_shape_str)
	var front_scanner_position = Vector2(Utils.get_collision_shape_long_side(car_shape_collision_shape) / 2 + get_front_scanner_length() / 2, -5)
	collision_shape.position = front_scanner_position

func update_front_scanner(car_velocity: Vector2, car_shape) -> void:
	update_front_scanner_shape(car_velocity)
	update_front_scanner_position(car_shape)

func set_body_in_front_scanner(body):
	bodies_in_range.append(body)

func _on_body_entered(body):
	if body.is_in_group(GroupNames.CAR_GROUP):
		set_body_in_front_scanner(body)
		return
	if body.is_in_group(GroupNames.TRAFFIC_LIGHT_GROUP):
		if body.state == Enums.TRAFFIC_LIGHT_STATES.RED:
			set_body_in_front_scanner(body)

func _on_body_exited(body):
	var body_idx = bodies_in_range.find(body)
	if not body_idx == -1:
		bodies_in_range.remove_at(body_idx)
