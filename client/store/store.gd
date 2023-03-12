extends Panel

var native_selected: bool = true

func update_supplies():
	var ability_tokens = await get_node("/root/w3").get_ability_tokens()
	var children = $ScrollContainer/VBoxContainer.get_children()
	for i in ability_tokens.size():
		children[i].get_node("HBoxContainer").set_supply(ability_tokens[i])


func update_prizes():
	var ability_rates = await get_node("/root/w3").get_ability_rates()
	var children = $ScrollContainer/VBoxContainer.get_children()
	for i in ability_rates.size():
		children[i].get_node("HBoxContainer").set_prize(ability_rates[i])

func toggle_native():
	for child in $ScrollContainer/VBoxContainer.get_children():
		child.get_node("HBoxContainer").toggle_native()
	if native_selected:
		$TextureRect2.visible = true
		$TextureRect.visible = false
	else:
		$TextureRect2.visible = false
		$TextureRect.visible = true
	
	native_selected = !native_selected

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(store_item.ability_icons.size()):
		var item_instance = load("res://store/store_item.tscn").instantiate()
		$ScrollContainer/VBoxContainer.add_child(item_instance)
		item_instance.get_node("HBoxContainer").init(i)
		if i % 2 == 0:
			item_instance.self_modulate.a = 0.0
	
	await update_prizes()
	await update_supplies()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_check_button_toggled(button_pressed):
	toggle_native()
