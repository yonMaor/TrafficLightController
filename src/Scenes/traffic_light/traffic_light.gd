extends CharacterBody2D

const GREEN = preload("res://Assets/Sprites/Image/TrafficLight/GREEN.png")
const RED = preload("res://Assets/Sprites/Image/TrafficLight/RED.png")
const YELLOW = preload("res://Assets/Sprites/Image/TrafficLight/YELLOW.png")

@onready var light = $Light
@onready var outline = $Outline

var state: Enums.TRAFFIC_LIGHT_STATES

var traffic_light_highlighted: bool = false
var is_blocking_traffic: bool = false

func set_color_state(color_state: Enums.TRAFFIC_LIGHT_STATES) -> void:
	var state_to_texture_color = {Enums.TRAFFIC_LIGHT_STATES.RED: RED, Enums.TRAFFIC_LIGHT_STATES.YELLOW: YELLOW, Enums.TRAFFIC_LIGHT_STATES.GREEN: GREEN}
	state = color_state
	light.texture = state_to_texture_color[state]
	#if state == Enums.TRAFFIC_LIGHT_STATES.RED:
		#light.texture = RED
	#if state == Enums.TRAFFIC_LIGHT_STATES.YELLOW:
		#light.texture = YELLOW
	#if state ==Enums.TRAFFIC_LIGHT_STATES.GREEN:
		#light.texture = GREEN
	
	light.position = Vector2(-35, -130)

# Called when the node enters the scene tree for the first time.
func _ready():
	outline.visible = false
	state = Enums.TRAFFIC_LIGHT_STATES.RED
	light.texture = RED
	set_color_state(Enums.TRAFFIC_LIGHT_STATES.RED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_is_blocking_traffic()

func check_is_blocking_traffic():
	if state == Enums.TRAFFIC_LIGHT_STATES.RED:
		is_blocking_traffic = true
	else:
		is_blocking_traffic = false

func _on_mouse_entered():
	outline.visible = true
	traffic_light_highlighted = true

func _on_mouse_exited():
	outline.visible = false
	traffic_light_highlighted = false

func get_next_state():
	var next_state = state + 1
	if state == Enums.TRAFFIC_LIGHT_STATES.GREEN:
		return Enums.TRAFFIC_LIGHT_STATES.RED
	#if state == Enums.TRAFFIC_LIGHT_STATES.GREEN:
		#return Enums.TRAFFIC_LIGHT_STATES.RED
	#if state == Enums.TRAFFIC_LIGHT_STATES.GREEN:
		#return Enums.TRAFFIC_LIGHT_STATES.RED
	return state + 1

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("changeTrafficLightState"):
		var next_state = get_next_state()
		set_color_state(next_state)
