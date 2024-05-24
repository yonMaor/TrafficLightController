extends Node

const KP: float = 1.5 # Proportional gain
const KI: float = 1.5 # Integral gain
const KD: float = 0.85 # Derivative gain

# Best working PID consts currently
#self.Kp = 0.5
#self.Ki = 0.015
#self.Kd = 0.75

const MAX_SPEED = 100
const MIN_SAFETY_DIST = 1.0
const MAX_BRAKING_FORCE = 0.01
const MAX_ACCELERATION = 1.0

const TARGET_DIST: float = 1.0

const SPEED: float = 40.0
const INITIAL_DIR: Vector2 = Vector2(1, 0)
#const ACCEL_BASE_FACTOR: float = 0.25
const base_acceleration: float = 0.5
const min_dist_to_target: float = 0.0
