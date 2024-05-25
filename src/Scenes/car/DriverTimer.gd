extends RichTextLabel

var ms = 0
var s = 0


func handle_timer() -> void:
	if ms > 9:
		s += 1
		ms = 0	
	set_text(str(s))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	handle_timer()
	


func _on_timer_timeout():
	ms += 1
