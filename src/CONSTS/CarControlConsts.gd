extends Node

const KP: float = 0.5 # Proportional gain
const KI: float = 0.1 # Integral gain
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
