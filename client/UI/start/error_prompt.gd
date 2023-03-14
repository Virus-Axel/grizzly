extends MarginContainer


func show_phantom_connect_error():
	$VBoxContainer/Label.text = "Phantom Error\n\nFailed to connect to phantom\nwallet. Make sure phantom is\ninstalled and try again."
	visible = true;

func show_client_error():
	$VBoxContainer/Label.text = "RPC Client Error\n\nFailed to connect to blockchain.\nCheck your network connection\nand try again."
	visible = true;

func show_buy_bear():
	$VBoxContainer/Label.text = "Buy Grizzly Bear\n\nBuy your own grizzly NFT.\nYou can send your grizzly to fight\nother bears in the arena.\n\nA new bear costs 0.1 sol"
	visible = true;
	
func show_no_bears():
	$VBoxContainer/Label.text = "No Bears Available\n\nNo bears are currently available.\nYou can try to refresh or\nbuy a new grizzly NFT by pressing\nthe bear button."
	visible = true;

func show_bear_bought():
	$VBoxContainer/Label.text = "Transaction Sent\n\nIt might take some seconds for\nyour bear to show up. Try refreshing\nin a couple of seconds."
	visible = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
