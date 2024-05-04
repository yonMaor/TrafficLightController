extends CharacterBody2D

@onready var front_scanner = $FrontScanner

const SPEED: float = 40.0
const MAX_SPEED: float = 100
const INITIAL_DIR: Vector2 = Vector2(1, 0)
const ACCEL_FACTOR: float = 0.1

var body_in_front_scanner: bool = false
var bodies_in_range: Array = []
var dist_to_min_target: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func calc_acceleration_type() -> int:
	# Returns 1 when accelerating, -1 when braking, and 0 when stopped
	if body_in_front_scanner:
		if velocity.length() < 1:
			return 0
		return -1
	else:
		return 1


func get_closest_body_and_range() -> Dictionary:
	var min_dist_body = null
	var front_scanner_shape = front_scanner.get_node("CollisionShape2D").get_shape().size
	var min_dist = max(front_scanner_shape[0], front_scanner_shape[1])
	if not bodies_in_range:
		return {}
	for body in bodies_in_range:
		var dist = (body.position - position).length()
		if dist < min_dist:
			min_dist = dist
			min_dist_body = body
			
	return {"min_dist": min_dist, "body": min_dist_body}


func calc_acceleration(acceleration, min_dist_dict) -> float:
	if min_dist_dict == {}:
		return 1.0
	return acceleration


func _process(delta) -> void:
	var acceleration = calc_acceleration_type()
	print(acceleration)
	var min_dist_dict = get_closest_body_and_range()
	acceleration = calc_acceleration(acceleration, min_dist_dict)
	acceleration *= ACCEL_FACTOR
	velocity = Vector2(1, 0).rotated(rotation) * min (velocity.length() + acceleration, MAX_SPEED)
	#print(velocity)
	#motion.x = min(motion.x + ACCEL_FACTOR, SPEED)
	move_and_slide()


func _on_front_scanner_body_entered(body):
	body_in_front_scanner = true
	bodies_in_range.append(body)
