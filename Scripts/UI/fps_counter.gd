extends Label

var fps_counter = 0

func _process(_delta: float) -> void:
	fps_counter = Engine.get_frames_per_second()
	text = "FPS: %s" %fps_counter
