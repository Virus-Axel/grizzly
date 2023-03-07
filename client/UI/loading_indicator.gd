extends Control

const ALPHA_PER_LEAF = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_text(text):
	$Label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in $leaves.get_child_count():
		var phase = float(i + 1) / $leaves.get_child_count()
		var lap_time = fmod($lap_timer.time_left / $lap_timer.wait_time + phase, 1.0)
		var alpha = ((lap_time))
		$leaves.get_children()[i].modulate.a = clamp(alpha, 0.0, 1.0)
	pass
