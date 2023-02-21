extends Node3D

const LAYERS = 10;
const FUR_LENGTH = 0.5;
const FUR_DENSITY = 0.9

func grow_scale():
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	var start = $male_Base_mesh;
	start.get_surface_override_material(0).set_shader_parameter("FUR_THICKNESS", 200.0);
	start.get_surface_override_material(0).set_shader_parameter("fur_color", Vector3(0.0, 0.0, 0.0));
	start.get_surface_override_material(0).set_shader_parameter("DENSITY", 1)
	for i in range(LAYERS):
		var shell_1 = start.duplicate()
		shell_1.set("blend_shapes/Key 1", FUR_LENGTH / LAYERS * i)
		shell_1.set_surface_override_material(0, shell_1.get_surface_override_material(0).duplicate(15))
		shell_1.get_surface_override_material(0).set_shader_parameter("FUR_THICKNESS", 0.8 - (1.0 - 1.0 * FUR_DENSITY) / LAYERS * i)
		shell_1.get_surface_override_material(0).set_shader_parameter("layer", i)
		shell_1.get_surface_override_material(0).set_shader_parameter("DENSITY", 700)
		shell_1.get_surface_override_material(0).set_shader_parameter("fur_color", Vector3(0.05 + 0.1 / LAYERS * i, 0.0, 0.0));
		add_child(shell_1)
	remove_child(start)
	add_child(start)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
