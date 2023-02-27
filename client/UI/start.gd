extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	#var a = PackedInt64Array([4281319108, 177002846, 261659528])
	#print(a[2] ^ ($Node.L32(a[0] + a[1], 9, true) % (1 << 32)))
	#print(bs58.decode(bs58.encode("hello".to_utf8_buffer())))
	#var json = JSON.new()
	#json.parse("{\"public_key\":\"8jWTFapkMZfRRMiYQ3PoJT7VEccs5Hj1UuPSDQeVg6KT\",\"session\":\"KrTL7GWPZ6RepNE68QWvX26DxnB4PAG2CtRdmBDTS5aRg8tyVwDAgfrqEPrrKwZ2FfPTLnvNCe6yHbtuXBq1kHVYEt4htfkKnJzqPck3WPWmdx8dPPzD2XBbfUdtFzujm5dKEx769PSYzzTQfPrciNRUAh9uvQm2r3isCirDx4iWrHEvm2fgFinDD2k4sHB12LXuTf5h572uUqgDngQuec\"}")
	#print(json.get_data())
	return
	await $w3.connect_phantom_wallet()
	print("entering next")
	$w3.phantom_send_transaction("hello")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_connect_phantom_button_pressed():
	await $w3.connect_phantom_wallet()
	pass # Replace with function body.
