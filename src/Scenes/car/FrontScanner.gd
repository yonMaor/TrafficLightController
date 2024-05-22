extends Area2D

var bodies_in_range: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_front_scanner_length():
	var front_scanner_collision_shape = get_node(StringConsts.body_collision_shape_str)
	return Utils.get_collision_shape_long_side(front_scanner_collision_shape)

func update_bodies_in_front_scanner():
	for body in bodies_in_range:
		if body.is_in_group(GroupNames.TRAFFIC_LIGHT_GROUP):
			if body.state != Enums.TRAFFIC_LIGHT_STATES.RED:
				bodies_in_range.erase(body)

# TODO: Refactor this mess of a function
func get_closest_body_and_range(car_shape, car_position) -> Dictionary:
	var min_dist_body = null
	var min_dist = get_front_scanner_length()
	
	for body in bodies_in_range:
		var body_collision_shape = body.get_node(StringConsts.body_collision_shape_str) #TODO: Every potential body needs to have a CollisionShape2D
		var body_length = max(body_collision_shape.shape.size[0], body_collision_shape.shape.size[1])
		var car_length = Utils.get_collision_shape_long_side(car_shape.get_node(StringConsts.body_collision_shape_str))
		# TODO: Fix to consider angle between the bodies
		var dist = (body.position - car_position).length() - body_length/2 - car_length/2
		#print(dist)
		if dist < min_dist:
			min_dist = dist
			min_dist_body = body

	return {StringConsts.MIN_DIST: min_dist, StringConsts.MIN_DIST_BODY: min_dist_body}

# TODO: Break this ugly function up to pieces
func resize_front_scanner(car_velocity: Vector2, car_shape) -> void:
	var base_search_length = 200 # TODO: Move this to consts file
	var velocity_factor = 1.0 # TODO: Move this to consts file
	var front_scanner_collision_shape = get_node(StringConsts.body_collision_shape_str)
	var front_scanner_collision_shape_width = Utils.get_collision_shape_short_side(front_scanner_collision_shape)
	var front_scanner_collision_shape_length = base_search_length + velocity_factor * car_velocity.length()
	front_scanner_collision_shape.shape.set_size(Vector2(front_scanner_collision_shape_width, front_scanner_collision_shape_length))
	var car_shape_collision_shape = car_shape.get_node(StringConsts.body_collision_shape_str)
	var front_scanner_position = Vector2(Utils.get_collision_shape_long_side(car_shape_collision_shape) / 2 + front_scanner_collision_shape_length / 2, -5)
	front_scanner_collision_shape.position = front_scanner_position

func set_body_in_front_scanner(body):
	print("HA")
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
