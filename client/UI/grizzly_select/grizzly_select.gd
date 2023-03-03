extends Node3D

const BEAR_SPACING: float = 5.0
const MIN_SWIPE_DISTANCE: int = 100.0
const CAMERA_SPEED = 2.0

var selected_index: int = -1
var keys = []

var mouse_click := Vector2()

func create_bear(attributes):
	var total_bears = $bears.get_child_count()
	var bear = load("res://grizzly_bear/bear.tscn").instantiate()
	bear.position = Vector3(total_bears * BEAR_SPACING, -1.3, -3.8);
	$bears.add_child(bear)
	bear.init(attributes)
	if selected_index == -1:
		selected_index = 0
		$CanvasLayer/loading_indicator.visible = false
		$CanvasLayer/MarginContainer/Button.visible = true
	print("new bear!")
	return bear
	

func add_selectable_bear(key_map):
	var w3 = get_node("/root/w3")
	var bear_data = await w3.get_bear_data(key_map[1])
	if bear_data == "":
		print("could not get bear data...")
		return
	keys.push_back(key_map)
	var decoded_data = bs64.decode(bear_data)
	var attributes = w3.get_attributes_from_data(decoded_data)
	var bear = create_bear(attributes)
	var new_light = $SpotLight3D.duplicate()
	new_light.position.x = $bears.get_child_count() * BEAR_SPACING;
	print(bear.position)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	var w3 = get_node("/root/w3")

	get_node("/root/w3").wallet_key = "9wxXgHP5trhtdQmqqmjPVXrrxXLEfQ1bxCvwemmivZxm"
	get_node("/root/w3").get_node("program_handler").setKeys("HJyMW82CKUrsbfTSKaNXdsgqcS1HJm8jAjbVVq3Uj4AN", "9wxXgHP5trhtdQmqqmjPVXrrxXLEfQ1bxCvwemmivZxm", w3.ID)
	#w3.create_account(33)
	#return
	#var nft_keys = await w3.get_nft_keys(w3.wallet_key)
	var nft_keys = await get_node("/root/w3").get_nft_keys("9wxXgHP5trhtdQmqqmjPVXrrxXLEfQ1bxCvwemmivZxm")
	for map in nft_keys:
		add_selectable_bear(map)
	#w3.mint_nft(w3.wallet_key)
	
	#print(nft_keys)
	pass # Replace with function body.

func hide_content():
	$CanvasLayer/loading_indicator.visible = false

func show_network_error():
	hide_content()
	$CanvasLayer/error_prompt.show_client_error()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera3D.position.x -= delta * ($Camera3D.position.x - BEAR_SPACING * selected_index) * CAMERA_SPEED
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			mouse_click = event.position
			$swipe_timer.start()
		else:
			if not $swipe_timer.is_stopped():
				if mouse_click.distance_to(event.position) > MIN_SWIPE_DISTANCE:
					if event.position.x < mouse_click.x:
						on_swipe_right()
					else:
						on_swipe_left()
			

func on_swipe_left():
	selected_index -= 1
	if selected_index < 0:
		selected_index += $bears.get_child_count()
	
func on_swipe_right():
	selected_index = (selected_index + 1) % $bears.get_child_count()

func _on_button_pressed():
	get_node("/root/w3").nft_map = keys[selected_index]
	print(get_node("/root/w3").nft_map)
	get_tree().change_scene_to_file("res://lobby/lobby.tscn")
	pass # Replace with function body.
