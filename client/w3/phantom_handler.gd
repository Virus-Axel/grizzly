extends HTTPRequest

const REDIRECT_LINK = "redirect_link%3Dgrizzly%3A%2F%2FonPhantomConnected"
const APP_URL = "godot://com.example.godotapp"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func connect_phantom():
	request(
		"https://phantom.app/ul/v1/connect?app_url=" +
		APP_URL +
		"redirect_link=" +
		REDIRECT_LINK
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
