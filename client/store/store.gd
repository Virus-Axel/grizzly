extends Panel


func update_supplies():
	var ability_tokens = await w3.get_ability_tokens()
	var children = $ScrollContainer/VBoxContainer.get_children()
	for i in ability_tokens.size():
		children[i].get_node("HBoxContainer").set_supply(ability_tokens[i])


func update_prizes():
	var ability_tokens = await w3.get_ability_tokens()
	var children = $ScrollContainer/VBoxContainer.get_children()
	for i in ability_tokens.size():
		children[i].get_node("HBoxContainer").set_prize(ability_tokens[i])

func toggle_native():
	for child in $ScrollContainer/VBoxContainer.get_children():
		child.get_node("HBoxContainer").toggle_native()

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(store_item.ability_icons.size()):
		var item_instance = load("res://store/store_item.tscn").instantiate()
		$ScrollContainer/VBoxContainer.add_child(item_instance)
		item_instance.get_node("HBoxContainer").init(i)
		if i % 2 == 0:
			item_instance.self_modulate.a = 0.0
	
	update_prizes()
	update_supplies()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_check_button_toggled(button_pressed):
	toggle_native()
