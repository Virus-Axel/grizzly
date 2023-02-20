extends Camera3D

var motion = Vector3(0.0, 0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_down"):
		motion.z = 0.01;
	if event.is_action_released("ui_down"):
		motion.z = 0.0;
	if event.is_action_pressed("ui_up"):
		motion.z = -0.01;
	if event.is_action_released("ui_up"):
		motion.z = -0.0;
	if event.is_action_pressed("ui_right"):
		motion.x = 0.01;
	if event.is_action_released("ui_right"):
		motion.x = 0.0;
	if event.is_action_pressed("ui_left"):
		motion.x = -0.01;
	if event.is_action_released("ui_left"):
		motion.x = -0.0;
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += motion
	pass
