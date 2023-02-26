extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Node.box_keypair()
	return
	await $w3.connect_phantom_wallet()
	print("entering next")
	$w3.phantom_send_transaction("hello")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
