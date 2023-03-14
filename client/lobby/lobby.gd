extends Node3D

var stats_shown: bool = false
var store_shown: bool = false
var fridge_shown: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$bear.get_node("AnimationPlayer").animation_finished.connect(Callable(self, "replay"))
	$bear.get_node("AnimationPlayer").play("ArmatureAction")
	#get_node("/root/w3").create_account(33 + 32*8);
	#await _on_shop_update_timeout()
	#var ID = get_node("/root/w3").ID
	
	#get_node("/root/w3").wallet_key = "9wxXgHP5trhtdQmqqmjPVXrrxXLEfQ1bxCvwemmivZxm"
	#get_node("/root/w3").get_node("program_handler").setKeys("HJyMW82CKUrsbfTSKaNXdsgqcS1HJm8jAjbVVq3Uj4AN", "9wxXgHP5trhtdQmqqmjPVXrrxXLEfQ1bxCvwemmivZxm", ID)

	#get_node("/root/w3").create_ability_token()
	#get_node("/root/w3").equip_ability_token(2)
	# Try to reveal secret
	

	
	#w3.equip_ability_token(1)
	var w3 = get_node("/root/w3")
	var bear_data = await w3.get_bear_data(w3.nft_map[1])
	var decoded_data = bs64.decode(bear_data)
	if decoded_data[0] != 0:
		get_tree().change_scene_to_file("res://UI/moveset_select/queue.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func send_bear_to_battle():
	var w3 = get_node("/root/w3")
	$CanvasLayer/moveset_select.visible = true
	$AnimationPlayer.play("hide_buttons")
	#w3.battle()


func _on_battle_button_pressed():
	send_bear_to_battle()


func _on_stats_button_pressed():
	for child in $CanvasLayer/HBoxContainer.get_children():
		child.disabled = true;
	$AnimationPlayer.play("stats")
	$ui_player.play("hide_buttons")
	stats_shown = true
	pass # Replace with function body.


func _on_store_button_pressed():
	for child in $CanvasLayer/HBoxContainer.get_children():
		child.disabled = true;
	$AnimationPlayer.play("store_view")
	$ui_player.play("hide_buttons")
	store_shown = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "store_view" and store_shown:
		$CanvasLayer/Panel.visible = true;


func _on_back_button_pressed():
	if stats_shown:
		$AnimationPlayer.play_backwards("stats")
		$ui_player.play_backwards("hide_buttons")
		stats_shown = false
	elif store_shown:
		$CanvasLayer/Panel.visible = false;
		$AnimationPlayer.play_backwards("store_view")
		$ui_player.play_backwards("hide_buttons")
		store_shown = false
	elif fridge_shown:
		$AnimationPlayer.play_backwards("fridge_view")
		$ui_player.play_backwards("hide_buttons")
		fridge_shown = false
	
	$CanvasLayer/moveset_select.visible = false
	
	for child in $CanvasLayer/HBoxContainer.get_children():
			child.disabled = false;


func _on_rank_button_pressed():
	for child in $CanvasLayer/HBoxContainer.get_children():
		child.disabled = true;
	$AnimationPlayer.play("fridge_view")
	$ui_player.play("hide_buttons")
	fridge_shown = true

func update_native_balance(new_balance):
	$CanvasLayer/VBoxContainer/HBoxContainer2/Label.text = str(new_balance)

func update_shop():
	var w3 = get_node("/root/w3")
	var ability_tokens = await w3.get_ability_tokens()
	var children = $CanvasLayer/VBoxContainer.get_children()
	for i in children.size():
		children[i].set_ability_tokens[i]

func _on_shop_update_timeout():
	var w3 = get_node("/root/w3")
	var native_balance = await w3.get_native_balance()
	update_native_balance(native_balance)

	await $CanvasLayer/Panel.update_supplies()
	#w3.get_ability_rates()
	await $CanvasLayer/Panel.update_prizes()
	$shop_update.start()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://UI/grizzly_select/grizzly_select.tscn")

func replay(name):
	$bear.get_node("AnimationPlayer").play("ArmatureAction")


func clear_data_remove():
	get_node("/root/w3").clear_bear_data()
	pass # Replace with function body.
