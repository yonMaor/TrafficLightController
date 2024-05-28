extends Control

@onready var progress_bar = $ProgressBar
@onready var timer = $Timer
@onready var rich_text_label = $RichTextLabel

var ms: int = 0
var s: int = 0

var style_box = StyleBoxFlat.new()
var debug_timer: bool = true

func handle_timer() -> void:
	if ms > 9:
		s += 1
		ms = 0	
		progress_bar.set_value(s)
		style_box.bg_color = TimerConsts.RED if s >= 40 else TimerConsts.ORANGE if s >= 20 else TimerConsts.GREEN
		progress_bar.add_theme_stylebox_override("fill", style_box)
		if debug_timer:
			rich_text_label.set_text(str(s))
			var color = TimerConsts.RED if s >= 40 else TimerConsts.ORANGE if s >= 20 else TimerConsts.GREEN
			rich_text_label.set("theme_override_colors/font_color", color)

# Called when the node enters the scene tree for the first time.
func _ready():
	style_box.bg_color = Color("ff0000")
	progress_bar.add_theme_stylebox_override("fill", style_box)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_timer()
	

func _on_timer_timeout():
	ms += 1
	#print(ms)
