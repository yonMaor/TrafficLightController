extends Node2D

class_name PIDController

var Kp: float
var Ki: float
var Kd: float
var d_desired: float

var integral: float = 0.0
var previous_error: float = 0.0
var integral_saturation: float = 0.01 # TODO: See if this is needed
var error_threshold: float = 1.0

func _init(Kp: float, Ki: float, Kd: float, d_desired: float) -> void:
	# TODO: Move these back to the consts file
	self.Kp = Kp
	self.Ki = Ki
	self.Kd = Kd
	self.d_desired = d_desired
	
func update(distance: float, delta: float) -> float:
	var error = distance - d_desired
	
	if abs(error) < error_threshold:
		integral = 0.0
	
	var proportional = calc_proportional_term(error)
	var derivative = calc_derivative_term(error, delta)
	integral += calc_integral_term(error, delta)
	integral = clamp(integral, -integral_saturation, integral_saturation)
	previous_error = error
	print(error)
	var output = proportional + derivative + integral
	
	if abs(error) < error_threshold:
		output = 0.0
	
	return output

func calc_proportional_term(error: float) -> float:
	return Kp * error

func calc_derivative_term(error: float, delta: float) -> float:
	if previous_error == 0:
		return 0
	return Kd * ((error - previous_error) / delta)

func calc_integral_term(error: float, delta: float) -> float:
	return Ki * (error * delta)
	
