extends Node3D

func grow_scale():
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	var start = $male_Base_mesh;
	start.get_surface_override_material(0).set_shader_parameter("FUR_THICKNESS", 1.0);
	start.get_surface_override_material(0).set_shader_parameter("fur_color", Vector3(0.0, 0.0, 0.0));
	for i in range(30):
		var shell_1 = start.duplicate()
		shell_1.set("blend_shapes/Key 1", 0.005 * i)
		shell_1.set_surface_override_material(0, shell_1.get_surface_override_material(0).duplicate(15))
		shell_1.get_surface_override_material(0).set_shader_parameter("FUR_THICKNESS", 0.3 - 0.008 * i)
		shell_1.get_surface_override_material(0).set_shader_parameter("fur_color", Vector3(0.05 + 0.01 * i, 0.0, 0.0));
		add_child(shell_1)
	remove_child(start)
	add_child(start)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
