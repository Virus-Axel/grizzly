extends Control

var change_ability: int = 0
var equipped_abilities = []

var toggle = true

func clear_ability_list():
	var parent = $VBoxContainer2/ScrollContainer/available_abilities
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()

func reload_unequipped():
	clear_ability_list()
	var ability_data = await get_node("/root/w3").get_current_moveset()
	
	for i in ability_data[1].size():
		var new_button = Button.new()
		new_button.flat = true
		new_button.icon = store_item.ability_icons[i]
		new_button.text = "LV " + str(ability_data[1][i]) + " - " + store_item.names[i]
		new_button.add_theme_font_size_override("font_size", 24)
		new_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		new_button.expand_icon = true
		new_button.custom_minimum_size.y = 100
		new_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		#if not ability_data[1][i]:
		#	new_button.visible = false
		
		$VBoxContainer2/ScrollContainer/available_abilities.add_child(new_button)
		new_button.pressed.connect(Callable(self, "replace_ability_with").bind(i))
	hide_inaccessable()

# Called when the node enters the scene tree for the first time.
func reload():
	clear_ability_list()
	var ability_data = await get_node("/root/w3").get_current_moveset()
	print(ability_data)
	equipped_abilities = ability_data[0]
	var children = $VBoxContainer/moves.get_children()
	for i in ability_data[0].size():
		children[i].icon = store_item.ability_icons[ability_data[0][i]]
		children[i].text = store_item.names[ability_data[0][i]]
	
	for i in ability_data[1].size():
		var new_button = Button.new()
		new_button.flat = true
		new_button.icon = store_item.ability_icons[i]
		new_button.text = "LV " + str(ability_data[1][i]) + " - " + store_item.names[i]
		new_button.add_theme_font_size_override("font_size", 24)
		new_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		new_button.expand_icon = true
		new_button.custom_minimum_size.y = 100
		new_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		#if not ability_data[1][i]:
		#	new_button.visible = false
		
		$VBoxContainer2/ScrollContainer/available_abilities.add_child(new_button)
		new_button.pressed.connect(Callable(self, "replace_ability_with").bind(i))
	hide_inaccessable()


func _ready():
	var children = $VBoxContainer/moves.get_children()
	for i in children.size():
		children[i].pressed.connect(Callable(self, "replace_ability").bind(i))
	reload()

func fade_base(strength: float):
	$VBoxContainer.modulate = Color(strength, strength, strength)

func replace_ability(index):
	change_ability = index
	$AnimationPlayer.stop()
	$AnimationPlayer.play("page_1")
	$VBoxContainer2.visible = true
	#fade_base(0.2)

func replace_ability_with(index):
	var child = $VBoxContainer/moves.get_child(change_ability)
	child.icon = store_item.ability_icons[index]
	child.text = store_item.names[index]
	
	print("showing ", index)
	print("not showing ", equipped_abilities[change_ability])
	$VBoxContainer2/ScrollContainer/available_abilities.get_child(index).visible = false
	$VBoxContainer2/ScrollContainer/available_abilities.get_child(equipped_abilities[change_ability]).visible = true
	
	$AnimationPlayer.play_backwards("page_1")
	$VBoxContainer.visible = true
	
	equipped_abilities[change_ability] = index
	#fade_base(1.0)
	pass

func hide_inaccessable():
	for index in equipped_abilities:
		$VBoxContainer2/ScrollContainer/available_abilities.get_child(index).visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	if $VBoxContainer2.modulate.a < 0.1:
		$VBoxContainer2.visible = false
	if $VBoxContainer.modulate.a < 0.1:
		$VBoxContainer.visible = false

func _on_button_pressed():
	reload_unequipped()
	pass # Replace with function body.


func _on_fight_button_pressed():
	await get_node("/root/w3").battle(equipped_abilities)
	get_tree().change_scene_to_file("res://UI/moveset_select/queue.tscn")
