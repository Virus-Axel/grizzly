extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var w3 = get_node("/root/w3")
	#var nft_keys = w3.get_nft_keys(w3.wallet_key)
	w3.mint_nft(w3.wallet_key)
	#print(nft_keys)
	pass # Replace with function body.

func hide_content():
	$CanvasLayer/loading_indicator.visible = false

func show_network_error():
	hide_content()
	$CanvasLayer/error_prompt.show_client_error()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
