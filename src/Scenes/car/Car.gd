extends CharacterBody2D

@onready var front_scanner = $FrontScanner
@onready var car_shape = $CarShape

const SPEED: float = 40.0
const MAX_SPEED: float = 100
const INITIAL_DIR: Vector2 = Vector2(1, 0)
#const ACCEL_BASE_FACTOR: float = 0.25
const base_acceleration: float = 0.5

var pid: PIDController

var bodies_in_range: Array = []
var min_dist_to_target: float = 50.0

var last_error: float = 0.0
var error_integral: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pid = PIDController.new(CarControlConsts.KP, CarControlConsts.KI, CarControlConsts.KD, min_dist_to_target)
	

func get_collision_shape_shape(collision_shape):
	return collision_shape.get_shape().size

func get_collision_shape_short_side(collision_shape: CollisionShape2D) -> float:
	var shape = get_collision_shape_shape(collision_shape)
	print(shape)
	return min(shape[0], shape[1])

func get_collision_shape_long_side(collision_shape) -> float:
	var shape = get_collision_shape_shape(collision_shape)
	return max(shape[0], shape[1])

func get_front_scanner_length():
	var front_scanner_collision_shape = front_scanner.get_node(StringConsts.body_collision_shape_str)
	return get_collision_shape_long_side(front_scanner_collision_shape)

# TODO: Refactor this mess of a function
# TODO: Consider moving this to the front scanner node
func get_closest_body_and_range() -> Dictionary:
	var min_dist_body = null
	var min_dist = get_front_scanner_length()
	
	for body in bodies_in_range:
		var body_collision_shape = body.get_node(StringConsts.body_collision_shape_str) #TODO: Every potential body needs to have a CollisionShape2D
		var body_length = max(body_collision_shape.shape.size[0], body_collision_shape.shape.size[1])
		var car_length = get_collision_shape_long_side(car_shape.get_node(StringConsts.body_collision_shape_str))
		# TODO: Fix to consider angle between the bodies
		var dist = (body.position - position).length() - body_length/2 - car_length/2
		#print(dist)
		if dist < min_dist:
			min_dist = dist
			min_dist_body = body
			
	return {StringConsts.MIN_DIST: min_dist, StringConsts.MIN_DIST_BODY: min_dist_body}

func update_bodies_in_front_scanner():
	for body in bodies_in_range:
		if body.is_in_group(GroupNames.TRAFFIC_LIGHT_GROUP):
			if body.state != Enums.TRAFFIC_LIGHT_STATES.RED:
				bodies_in_range.erase(body)

# ==============================================================
func calculate_acceleration():
	pass

# ==============================================================

func apply_acceleration(acceleration: float, delta: float) -> void:
	var prev_velocity: Vector2 = velocity
	velocity += acceleration * Vector2(1, 0).rotated(rotation)
	if velocity.length() > MAX_SPEED:
		velocity = prev_velocity

# TODO: Move this functionality to the front scanner
# TODO: Break this ugly function up to pieces
func resize_front_scanner(velocity: Vector2) -> void:
	var base_search_length = 200 # TODO: Move this to consts file
	var velocity_factor = 1.0 # TODO: Move this to consts file
	var front_scanner_collision_shape = front_scanner.get_node(StringConsts.body_collision_shape_str)
	var front_scanner_collision_shape_width = get_collision_shape_short_side(front_scanner_collision_shape)
	var front_scanner_collision_shape_length = base_search_length + velocity_factor * velocity.length()
	front_scanner_collision_shape.shape.set_size(Vector2(front_scanner_collision_shape_width, front_scanner_collision_shape_length))
	var car_shape_collision_shape = car_shape.get_node(StringConsts.body_collision_shape_str)
	#print(Vector2(get_collision_shape_long_side(car_shape_collision_shape) * 1.5, 0))
	var front_scanner_position = Vector2(get_collision_shape_long_side(car_shape_collision_shape) / 2 + front_scanner_collision_shape_length / 2, -5)
	front_scanner_collision_shape.position = front_scanner_position
	# TODO: Need to adjust location of the front scanner when resizing
	
func _process(delta):
	resize_front_scanner(velocity)
	var closest_body = get_closest_body_and_range()
	var acceleration = base_acceleration
	if closest_body[StringConsts.MIN_DIST_BODY] == null:
		pass
	else:
		var pid_output = pid.update(closest_body[StringConsts.MIN_DIST], delta)
		acceleration = pid_output * base_acceleration
	apply_acceleration(acceleration, delta)
	#front_scanner.resize_scanner_length(velocity) #TODO: Need to write this function
	move_and_slide()	

func get_current_velocity_length():
	return velocity.length()

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
