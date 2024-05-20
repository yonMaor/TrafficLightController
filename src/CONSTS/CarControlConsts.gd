extends Node

const KP: float = 1.0 # Proportional gain
const KI: float = 0.3 # Integral gain
const KD: float = 1.0 # Derivative gain

const MAX_SPEED = 100
const MIN_SAFETY_DIST = 1.0
const MAX_BRAKING_FORCE = 0.01
const MAX_ACCELERATION = 1.0

const TARGET_DIST: float = 1.0
