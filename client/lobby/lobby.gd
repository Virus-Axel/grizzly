extends Node3D

var stats_shown: bool = false
var store_shown: bool = false
var fridge_shown: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#var ID = get_node("/root/w3").ID
	
	#get_node("/root/w3").wallet_key = "9wxXgHP5trhtdQmqqmjPVXrrxXLEfQ1bxCvwemmivZxm"
	#get_node("/root/w3").get_node("program_handler").setKeys("HJyMW82CKUrsbfTSKaNXdsgqcS1HJm8jAjbVVq3Uj4AN", "9wxXgHP5trhtdQmqqmjPVXrrxXLEfQ1bxCvwemmivZxm", ID)

	#get_node("/root/w3").clear_bear_data()
	#get_node("/root/w3").create_ability_token()
	#get_node("/root/w3").equip_ability_token(2)
	return
	# Try to reveal secret
	var w3 = get_node("/root/w3")
	var ability_tokens = await w3.get_ability_tokens()
	var children = $CanvasLayer/VBoxContainer.get_children()
	for i in children.size():
		children[i].text = str(ability_tokens[i])

	
	#w3.equip_ability_token(1)
	return
	
	if await w3.is_opponent_ready(w3.nft_map[1]):
		if await w3.reveal_secret():
			print("Commited to previous battle")
		else:
			print("Failed to commmit to last battle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_poll_timer_timeout():
	var w3 = get_node("/root/w3")
	if await w3.is_opponent_ready(w3.nft_map[1]):
		if await w3.reveal_secret():
			$poll_timer.stop()
			print("Commited to previous battle")
		else:
			print("Failed to commmit to last battle")


func send_bear_to_battle():
	var w3 = get_node("/root/w3")
	w3.battle()
	var challenging_bear = await w3.get_challenging_bear()
	if challenging_bear == "":
		$poll_timer.start()


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
	
	for child in $CanvasLayer/HBoxContainer.get_children():
			child.disabled = false;


func _on_rank_button_pressed():
	for child in $CanvasLayer/HBoxContainer.get_children():
		child.disabled = true;
	$AnimationPlayer.play("fridge_view")
	$ui_player.play("hide_buttons")
	fridge_shown = true
