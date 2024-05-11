extends Area2D

const GREEN = preload("res://Assets/Sprites/Image/TrafficLight/GREEN.png")
const RED = preload("res://Assets/Sprites/Image/TrafficLight/RED.png")
const YELLOW = preload("res://Assets/Sprites/Image/TrafficLight/YELLOW.png")

@onready var light = $Light
@onready var outline = $Outline

var state: Enums.TRAFFIC_LIGHT_STATES

func set_color_state(color_state: Enums.TRAFFIC_LIGHT_STATES):
	state = color_state
	if state == Enums.TRAFFIC_LIGHT_STATES.RED:
		light.texture = RED
	if state == Enums.TRAFFIC_LIGHT_STATES.YELLOW:
		light.texture = YELLOW
	if state ==Enums.TRAFFIC_LIGHT_STATES.GREEN:
		light.texture = GREEN
	
	light.position = Vector2(-35, -130)

# Called when the node enters the scene tree for the first time.
func _ready():
	outline.visible = false
	state = Enums.TRAFFIC_LIGHT_STATES.RED
	light.texture = RED
	set_color_state(Enums.TRAFFIC_LIGHT_STATES.RED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_mouse_entered():
	print("ON")
	outline.visible = true

func _on_mouse_exited():
	print("OFF")
	outline.visible = false
