extends RigidBody2D

var accelerator_factor = 30.0
var turn_factor = 3.5

var acceleration_input = 0
var steering_input = 0

var rotation_angle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	apply_engine_force()
	apply_steering()
	
func should_break():
	var scanner = get_node("FrontScanner")
	
	
	
	
func update_acceleration_input():
	
	if should_break:
		return -1
	return 1
		
		
	
func apply_engine_force() -> void:
	update_acceleration_input()
	var engine_force_vector = -transform.y * accelerator_factor * acceleration_input
	
	
func apply_steering() -> void:
	var steering_moment_vector = 0.0
	
	
	
