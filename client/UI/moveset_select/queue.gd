extends Control

func _on_poll_timer_timeout():
	var w3 = get_node("/root/w3")
	if await w3.is_opponent_ready(w3.nft_map[1]):
		if await w3.reveal_secret():
			$poll_timer.stop()
			print("Commited to previous battle")
			$poll_2.start()
		else:
			print("Failed to commmit to last battle")


# Called when the node enters the scene tree for the first time.
func _ready():
	var w3 = get_node("/root/w3")
	var bear_data = await w3.get_bear_data(w3.nft_map[1])
	var decoded_data = bs64.decode(bear_data)
	
	var challenging_bear = await w3.get_challenging_bear()
	if challenging_bear == "" or decoded_data[0] == 1:
		$poll_timer.start()
	else:
		$confirm_timer.start()
		$loading_indicator.get_node("Label").text = "Waiting for Confirmation..."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_confirm_timer_timeout():
	var w3 = get_node("/root/w3")
	var bear_data = await w3.get_bear_data(w3.nft_map[1], "processed")
	var decoded_data = bs64.decode(bear_data)
	if decoded_data[0] == 0:
		get_tree().change_scene_to_file("res://arena.tscn")
	pass # Replace with function body.


func _on_poll_2_timeout():
	var w3 = get_node("/root/w3")
	var bear_data = await w3.get_bear_data(w3.nft_map[1])
	var decoded_data = bs64.decode(bear_data)
	
	if decoded_data[0] == 0:
		get_tree().change_scene_to_file("res://arena.tscn")
	pass # Replace with function body.
