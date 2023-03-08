extends Node3D

const BEAR_SPACING: float = 5.0
const MIN_SWIPE_DISTANCE: int = 100.0
const CAMERA_SPEED = 2.0

var selected_index: int = -1
var keys = []

var mouse_click := Vector2()
var freeze_swipe = false

func update_arrows():
	if selected_index > 0:
		$CanvasLayer/left_arrow.visible = true
	else:
		$CanvasLayer/left_arrow.visible = false
	if selected_index < $SubViewportContainer/SubViewport/bears.get_child_count() - 1:
		$CanvasLayer/right_arrow.visible = true
	else:
		$CanvasLayer/right_arrow.visible = false

func create_bear(attributes):
	var total_bears = $SubViewportContainer/SubViewport/bears.get_child_count()
	var bear = load("res://grizzly_bear/bear.tscn").instantiate()
	bear.position = Vector3(total_bears * BEAR_SPACING, -1.3, -3.45);
	$SubViewportContainer/SubViewport/bears.add_child(bear)
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
	var new_light = $SubViewportContainer/SubViewport/SpotLight3D.duplicate()
	new_light.position.x = $SubViewportContainer/SubViewport/bears.get_child_count() * BEAR_SPACING;
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	fade_base(0.4)
	$AnimationPlayer.play("fog")
	var w3 = get_node("/root/w3")

	get_node("/root/w3").wallet_key = "9wxXgHP5trhtdQmqqmjPVXrrxXLEfQ1bxCvwemmivZxm"
	get_node("/root/w3").get_node("program_handler").setKeys("HJyMW82CKUrsbfTSKaNXdsgqcS1HJm8jAjbVVq3Uj4AN", "9wxXgHP5trhtdQmqqmjPVXrrxXLEfQ1bxCvwemmivZxm", w3.ID)
	#w3.create_account(33)
	#return
	#var nft_keys = await w3.get_nft_keys(w3.wallet_key)
	var nft_keys = await get_node("/root/w3").get_nft_keys("9wxXgHP5trhtdQmqqmjPVXrrxXLEfQ1bxCvwemmivZxm")
	for map in nft_keys:
		add_selectable_bear(map)
	
	fade_base(1.0)
	update_arrows()
	
	if $SubViewportContainer/SubViewport/bears.get_child_count() == 0:
		$CanvasLayer/error_prompt.show_no_bears()
	#w3.mint_nft(w3.wallet_key)
	else:
		$CanvasLayer/MarginContainer/Button.disabled = false
	#print(nft_keys)
	pass # Replace with function body.

func hide_content():
	$CanvasLayer/loading_indicator.visible = false

func show_network_error():
	hide_content()
	$CanvasLayer/error_prompt.show_client_error()

func move_world(delta):
	$SubViewportContainer/SubViewport/Camera3D.position.x -= delta * ($SubViewportContainer/SubViewport/Camera3D.position.x - BEAR_SPACING * selected_index) * CAMERA_SPEED
	$bear_select.position.x = $SubViewportContainer/SubViewport/Camera3D.position.x
	$SubViewportContainer/SubViewport/SpotLight3D.position.x = $SubViewportContainer/SubViewport/Camera3D.position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$SubViewportContainer/SubViewport/Camera3D.position.x -= delta * ($SubViewportContainer/SubViewport/Camera3D.position.x - BEAR_SPACING * selected_index) * CAMERA_SPEED
	move_world(delta)
	pass
	
func _input(event):
	if event is InputEventMouseButton and not freeze_swipe:
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
		selected_index += $SubViewportContainer/SubViewport/bears.get_child_count()
	update_arrows()

	
func on_swipe_right():
	selected_index = (selected_index + 1) % $SubViewportContainer/SubViewport/bears.get_child_count()
	update_arrows()

func _on_button_pressed():
	get_node("/root/w3").nft_map = keys[selected_index]
	print(get_node("/root/w3").nft_map)
	get_tree().change_scene_to_file("res://lobby/lobby.tscn")
	pass # Replace with function body.

func fade_base(strength):
	$SubViewportContainer.modulate = Color(strength, strength, strength)
	$CanvasLayer/MarginContainer.modulate = Color(strength, strength, strength)
	$Control.modulate = Color(strength, strength, strength)

func show_buy_buttons(vis = true):
	$CanvasLayer/Button4.visible = vis
	$CanvasLayer/Button.visible = vis

func _on_button_2_pressed():
	$CanvasLayer/error_prompt.show_buy_bear()
	show_buy_buttons()
	fade_base(0.4)
	pass # Replace with function body.

func _on_button_4_pressed():
	show_buy_buttons(false)
	fade_base(1.0)
	$CanvasLayer/error_prompt.visible = false
	$CanvasLayer/TextEdit.visible = false
	if $SubViewportContainer/SubViewport/bears.get_child_count() == 0:
		$CanvasLayer/error_prompt.show_no_bears()
	pass # Replace with function body.

func _on_mint_button():
	if $CanvasLayer/TextEdit.visible:
		if $CanvasLayer/TextEdit.text == "":
			return
		show_buy_buttons(false)
		$CanvasLayer/TextEdit.visible = false
		$CanvasLayer/error_prompt.visible = false
		$CanvasLayer/loading_indicator.set_text("Processing Transaction...")
		$CanvasLayer/loading_indicator.visible = true
		var bear_name = $CanvasLayer/TextEdit.text
		var w3 = get_node("/root/w3")
		#await w3.mint_nft(w3.wallet_key, bear_name)
		$CanvasLayer/loading_indicator.visible = false
		show_buy_buttons(false)
		fade_base(1.0)
		$CanvasLayer/error_prompt.show_bear_bought()
	else:
		$CanvasLayer/error_prompt.visible = false
		$CanvasLayer/TextEdit.visible = true
		$CanvasLayer/TextEdit.visible
		
	pass # Replace with function body.


func _on_refresh_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://UI/start.tscn")
	pass # Replace with function body.

