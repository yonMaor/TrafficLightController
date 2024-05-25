extends Label

var ms = 0
var s = 37


func handle_timer() -> void:
	if ms > 9:
		s += 1
		ms = 0	
	if s < 20:
		var green = Color(0.0, 1.0, 0.0)
		set("theme_override_colors/font_color", green)
	elif s >= 20 and s < 40:
		var orange = Color(1.0, 0.6, 0.0)
		set("theme_override_colors/font_color", orange)
	elif s >= 40:
		var red = Color(1.0, 0.0, 0.0)
		set("theme_override_colors/font_color", red)
		
	set_text(str(s))
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	handle_timer()
	


func _on_timer_timeout():
	ms += 1
