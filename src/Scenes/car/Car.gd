extends CharacterBody2D

@onready var front_scanner = $FrontScanner
@onready var car_shape = $CarShape

# TODO: Organize constants and erase or move to CarControlConsts.gd
var pid: PIDController

var is_blocking_traffic: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pid = PIDController.new(CarControlConsts.KP, CarControlConsts.KI, CarControlConsts.KD, CarControlConsts.min_dist_to_target)

# ==============================================================
func calculate_acceleration(delta) -> float:
	var closest_body = front_scanner.get_closest_body_and_range(car_shape, position)
	var acceleration = CarControlConsts.base_acceleration
	if closest_body[StringConsts.MIN_DIST_BODY] == null:
		pass
	else:
		if velocity.length() < 2.0:
			acceleration = 0
		else:
			var pid_output = pid.update(closest_body[StringConsts.MIN_DIST], delta)
			acceleration = pid_output * CarControlConsts.base_acceleration
	return acceleration
# ==============================================================

func apply_acceleration(acceleration: float, delta: float) -> void:
	var prev_velocity: Vector2 = velocity
	velocity += acceleration * Vector2(1, 0).rotated(rotation)
	if velocity.length() > CarControlConsts.MAX_SPEED:
		velocity = prev_velocity

# TODO: Move acceleration logic from here to a separate function
func _process(delta):
	front_scanner.update_front_scanner(velocity, car_shape)
	var acceleration = calculate_acceleration(delta)
	apply_acceleration(acceleration, delta)
	move_and_slide()
