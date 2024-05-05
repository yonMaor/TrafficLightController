extends CharacterBody2D

@onready var front_scanner = $FrontScanner

const SPEED: float = 40.0
const MAX_SPEED: float = 100
const INITIAL_DIR: Vector2 = Vector2(1, 0)
const ACCEL_BASE_FACTOR: float = 5.0

var body_in_front_scanner: bool = false
var bodies_in_range: Array = []
var dist_to_min_target: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func calc_acceleration_type() -> int:
	# Returns 1 when accelerating, -1 when braking, and 0 when stopped
	# TODO: Decision needs to also be based on the change in the closest object dist
	if body_in_front_scanner:
		if velocity.length() < 1:
			return 0
		return -1
	else:
		return 1


func get_front_scanner_length() -> float:
	var front_scanner_shape = front_scanner.get_node("CollisionShape2D").get_shape().size
	return max(front_scanner_shape[0], front_scanner_shape[1])


func get_closest_body_and_range() -> Dictionary:
	var min_dist_body = null
	var min_dist = get_front_scanner_length()
	if not bodies_in_range:
		return {}
	for body in bodies_in_range:
		var body_collision_shape = body.get_node("CollisionShape2D") #TODO: Should check if this returns anything
		var body_length = max(body_collision_shape.shape.size[0], body_collision_shape.shape.size[1])
		var dist = (body.position - position).length()
		if dist < min_dist:
			min_dist = dist
			min_dist_body = body
			
	return {"min_dist": min_dist, "body": min_dist_body}


func calc_acceleration(min_dist_dict) -> float:
	var acceleration_ratio = 1.0
	if min_dist_dict == {}:
		return acceleration_ratio
	else:
		var front_scanner_length = get_front_scanner_length()
		acceleration_ratio = 1 - min_dist_dict["min_dist"] / (0.5 * front_scanner_length)
	return acceleration_ratio


func _process(delta) -> void:
	var acceleration_dir = calc_acceleration_type()
	#print("acceleration_dir=" + str(acceleration_dir))
	var min_dist_dict = get_closest_body_and_range()
	var acceleration_ratio = calc_acceleration(min_dist_dict)
	#print("acceleration_ratio=" + str(acceleration_ratio))
	var acceleration = acceleration_ratio * ACCEL_BASE_FACTOR * acceleration_dir
	print(acceleration)
	velocity = Vector2(1, 0).rotated(rotation) * min (velocity.length() + acceleration, MAX_SPEED)
	#print(velocity)
	move_and_slide()


func _on_front_scanner_body_entered(body):
	# TODO: Need to check type of object
	# TODO: For traffic light, check if green or red
	body_in_front_scanner = true
	bodies_in_range.append(body)


func _on_front_scanner_body_exited(body):
	var body_idx = bodies_in_range.find(body)
	if not body_idx == -1:
		bodies_in_range.remove_at(body_idx)
