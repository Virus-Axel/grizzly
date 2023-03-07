extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("/root/w3").clear_bear_data()
	#get_node("/root/w3").create_ability_token()
	#get_node("/root/w3").equip_ability_token(2)
	#return
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

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	var w3 = get_node("/root/w3")
	w3.battle()
	var challenging_bear = await w3.get_challenging_bear()
	if challenging_bear == "":
		$poll_timer.start()


func _on_poll_timer_timeout():
	var w3 = get_node("/root/w3")
	if await w3.is_opponent_ready(w3.nft_map[1]):
		if await w3.reveal_secret():
			$poll_timer.stop()
			print("Commited to previous battle")
		else:
			print("Failed to commmit to last battle")
	pass # Replace with function body.
