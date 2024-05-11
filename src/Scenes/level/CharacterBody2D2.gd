extends CharacterBody2D

var SPEED = 80
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * SPEED
	move_and_slide()
