extends Label

@onready var progress_bar = $"../ProgressBar"


var ms = 0
var s:float = 0

func handle_timer() -> void:
	if ms > 9:
		s += 1
		ms = 0	
		progress_bar
		
	var color = TimerConsts.RED if s >= 40 else TimerConsts.ORANGE if s >= 20 else TimerConsts.GREEN
	set("theme_override_colors/font_color", color)
		
	set_text(str(s))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	handle_timer()
#
func _on_timer_timeout():
	ms += 1
