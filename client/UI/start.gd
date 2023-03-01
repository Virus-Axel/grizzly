extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	var id = get_node("/root/w3").ID
	get_node("/root/w3").get_node("program_handler").setKeys("HJyMW82CKUrsbfTSKaNXdsgqcS1HJm8jAjbVVq3Uj4AN", "9wxXgHP5trhtdQmqqmjPVXrrxXLEfQ1bxCvwemmivZxm", id)
	get_node("/root/w3").mint_nft("9wxXgHP5trhtdQmqqmjPVXrrxXLEfQ1bxCvwemmivZxm")
	return;
	get_node("/root/w3").connect_response.connect(Callable(self, "_on_w_3_connect_response"))
	#var a = PackedInt64Array([4281319108, 177002846, 261659528])
	#print(a[2] ^ ($Node.L32(a[0] + a[1], 9, true) % (1 << 32)))
	#print(bs58.decode(bs58.encode("hello".to_utf8_buffer())))
	#var json = JSON.new()
	#json.parse("{\"public_key\":\"8jWTFapkMZfRRMiYQ3PoJT7VEccs5Hj1UuPSDQeVg6KT\",\"session\":\"KrTL7GWPZ6RepNE68QWvX26DxnB4PAG2CtRdmBDTS5aRg8tyVwDAgfrqEPrrKwZ2FfPTLnvNCe6yHbtuXBq1kHVYEt4htfkKnJzqPck3WPWmdx8dPPzD2XBbfUdtFzujm5dKEx769PSYzzTQfPrciNRUAh9uvQm2r3isCirDx4iWrHEvm2fgFinDD2k4sHB12LXuTf5h572uUqgDngQuec\"}")
	#print(json.get_data())
	return
	await get_node("/root/w3").connect_phantom_wallet()
	print("entering next")
	get_node("/root/w3").phantom_send_transaction("hello")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_connect_phantom_button_pressed():
	$MarginContainer/VBoxContainer/connect_phantom_button.visible = false
	$loading_indicator.visible = true;
	get_node("/root/w3").connect_phantom_wallet()
		
func _on_w_3_connect_response():
	$loading_indicator.visible = false;
	if get_node("/root/w3").wallet_key == "":
		$MarginContainer/VBoxContainer/connect_phantom_button.visible = false
		$error_prompt.show_phantom_connect_error()
	get_tree().change_scene_to_file("res://UI/grizzly_select/grizzly_select.tscn")
	pass # Replace with function body.
