extends CharacterBody2D

@onready var front_scanner = $FrontScanner
@onready var car_shape = $CarShape

# TODO: Organize constants and erase or move to CarControlConsts.gd
const SPEED: float = 40.0
const MAX_SPEED: float = 100
const INITIAL_DIR: Vector2 = Vector2(1, 0)
#const ACCEL_BASE_FACTOR: float = 0.25
const base_acceleration: float = 0.5

var pid: PIDController

var min_dist_to_target: float = 50.0

var last_error: float = 0.0
var error_integral: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pid = PIDController.new(CarControlConsts.KP, CarControlConsts.KI, CarControlConsts.KD, min_dist_to_target)

# ==============================================================
func calculate_acceleration():
	pass

# ==============================================================

func apply_acceleration(acceleration: float, delta: float) -> void:
	var prev_velocity: Vector2 = velocity
	velocity += acceleration * Vector2(1, 0).rotated(rotation)
	if velocity.length() > MAX_SPEED:
		velocity = prev_velocity

# TODO: Move acceleration logic from here to a separate function
func _process(delta):
	front_scanner.resize_front_scanner(velocity, car_shape)
	var closest_body = front_scanner.get_closest_body_and_range(car_shape, position)
	var acceleration = base_acceleration
	if closest_body[StringConsts.MIN_DIST_BODY] == null:
		pass
	else:
		var pid_output = pid.update(closest_body[StringConsts.MIN_DIST], delta)
		acceleration = pid_output * base_acceleration
	apply_acceleration(acceleration, delta)
	#front_scanner.resize_scanner_length(velocity) #TODO: Need to write this function
	move_and_slide()

