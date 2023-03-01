extends MarginContainer


func show_phantom_connect_error():
	$VBoxContainer/Label.text = "Phantom Error\n\nFailed to connect to phantom\nwallet. Make sure phantom is\ninstalled and try again."
	visible = true;

func show_client_error():
	$VBoxContainer/Label.text = "RPC Client Error\n\nFailed to connect to blockchain.\nCheck your network connection\nand try again."
	visible = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
