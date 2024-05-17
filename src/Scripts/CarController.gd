extends CharacterBody2D

@onready var front_scanner = $FrontScanner
@onready var car_shape = $CarShape

const SPEED: float = 40.0
const MAX_SPEED: float = 100
const INITIAL_DIR: Vector2 = Vector2(1, 0)
const ACCEL_BASE_FACTOR: float = 0.25

var bodies_in_range: Array = []
var dist_to_min_target: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func calc_acceleration_dir() -> int:
	# Returns 1 when accelerating, -1 when braking, and 0 when stopped
	# TODO: Decision needs to also be based on the change in the closest object dist
	if bodies_in_range:
		# TODO: Check why car isn't stopping completely at low speed
		if velocity.length() < 1:
			return Enums.ACCEL_DIR_STATES.STOP
		return Enums.ACCEL_DIR_STATES.BACKWARD
	else:
		return Enums.ACCEL_DIR_STATES.FORWARD

func get_collision_shape_shape(collision_shape):
	return collision_shape.get_shape().size

func get_collision_shape_short_side(collision_shape: CollisionShape2D) -> float:
	var shape = get_collision_shape_shape(collision_shape)
	return min(shape[0], shape[1])

func get_collision_shape_long_side(collision_shape) -> float:
	var shape = get_collision_shape_shape(collision_shape)
	return max(shape[0], shape[1])

func get_front_scanner_length(front_scanner):
	var front_scanner_collision_shape = front_scanner.get_node(Consts.body_collision_shape_str)
	return get_collision_shape_long_side(front_scanner_collision_shape)

# TODO: Refactor this mess of a function
# TODO: Consider moving this to the front scanner node
func get_closest_body_and_range() -> Dictionary:
	var min_dist_body = null
	var min_dist = get_front_scanner_length(front_scanner)
	
	for body in bodies_in_range:
		var body_collision_shape = body.get_node(Consts.body_collision_shape_str) #TODO: Every potential body needs to have a CollisionShape2D
		var body_length = max(body_collision_shape.shape.size[0], body_collision_shape.shape.size[1])
		var car_length = get_collision_shape_long_side(car_shape.get_node(Consts.body_collision_shape_str))
		# TODO: Fix to consider angle between the bodies
		var dist = (body.position - position).length() - body_length/2 - car_length/2
		#print(dist)
		if dist < min_dist:
			min_dist = dist
			min_dist_body = body
			
	return {Consts.MIN_DIST: min_dist, Consts.MIN_DIST_BODY: min_dist_body}

func calc_acceleration_ratio(min_dist_dict) -> float:
	var acceleration_ratio = 1.0
	if min_dist_dict[Consts.MIN_DIST_BODY] == null:
		return acceleration_ratio
	else:
		var front_scanner_length = get_front_scanner_length(front_scanner)
		acceleration_ratio = 1 - min_dist_dict[Consts.MIN_DIST] / (front_scanner_length)
	return acceleration_ratio

func calc_acceleration():
	var acceleration_dir = calc_acceleration_dir()
	var min_dist_body = get_closest_body_and_range()
	var acceleration_ratio = calc_acceleration_ratio(min_dist_body)
	return acceleration_ratio * ACCEL_BASE_FACTOR * acceleration_dir

func update_bodies_in_front_scanner():
	for body in bodies_in_range:
		if body.is_in_group(GroupNames.TRAFFIC_LIGHT_GROUP):
			if body.state != Enums.TRAFFIC_LIGHT_STATES.RED:
				bodies_in_range.erase(body)

func _process(delta) -> void:
	update_bodies_in_front_scanner()
	var acceleration = calc_acceleration()
	velocity = Vector2(1, 0).rotated(rotation) * min (velocity.length() + acceleration, MAX_SPEED)
	move_and_slide()

func set_body_in_front_scanner(body):
	bodies_in_range.append(body)

func _on_front_scanner_body_entered(body):
	if body.is_in_group(GroupNames.CAR_GROUP):
		set_body_in_front_scanner(body)
		return
	if body.is_in_group(GroupNames.TRAFFIC_LIGHT_GROUP):
		if body.state == Enums.TRAFFIC_LIGHT_STATES.RED:
			set_body_in_front_scanner(body)

func _on_front_scanner_body_exited(body):
	var body_idx = bodies_in_range.find(body)
	if not body_idx == -1:
		bodies_in_range.remove_at(body_idx)
