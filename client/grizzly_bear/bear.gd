extends Node3D

const LAYERS = 10;
const FUR_LENGTH = 1.0;
const FUR_DENSITY = 1.0
const color = Vector3(0.3, 0.10, 0.0);

func grow_scale():
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	var start = $Sphere028;
	var skin_material = StandardMaterial3D.new();
	skin_material.albedo_color = Color.BLACK
	var transparent_material = StandardMaterial3D.new();
	transparent_material.transparency = true
	transparent_material.albedo_color = Color(0.0, 0.0, 0.0, 0.0)
	#start.get_surface_override_material(0).set_shader_parameter("FUR_THICKNESS", 200.0);
	#start.get_surface_override_material(0).set_shader_parameter("fur_color", color / 3);
	#start.get_surface_override_material(0).set_shader_parameter("DENSITY", 1)
	for i in range(LAYERS):
		var shell_1 = start.duplicate()
		#print(FUR_LENGTH / LAYERS * (i + 1));
		shell_1.set("blend_shapes/fur", FUR_LENGTH / LAYERS * (i+1))
		shell_1.set_surface_override_material(0, shell_1.get_surface_override_material(0).duplicate(15))
		shell_1.get_surface_override_material(0).set_shader_parameter("FUR_THICKNESS", 0.8 - (1.0 - 1.0 * FUR_DENSITY) / LAYERS * (i+1))
		shell_1.get_surface_override_material(0).set_shader_parameter("layer", i+1)
		shell_1.get_surface_override_material(0).set_shader_parameter("DENSITY", FUR_DENSITY)
		shell_1.get_surface_override_material(0).set_shader_parameter("fur_color", color * (float(i+1) / LAYERS));
		shell_1.set_surface_override_material(1, transparent_material)
		shell_1.set_surface_override_material(2, transparent_material)
		add_child(shell_1)
	pass # Replace with function body.
	start.set_surface_override_material(0, skin_material)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
