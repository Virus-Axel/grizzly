extends HBoxContainer
class_name store_item

const LAMPORTS_PER_NATIVE: int = 50000

var index = -1
var native = true
var prize = 0

const ability_icons = [
	preload("res://store/1.png"),
	preload("res://store/2.png"),
	preload("res://store/3.png"),
	preload("res://store/4.png"),
	preload("res://store/5.png"),
	preload("res://store/6.png"),
	preload("res://store/7.png"),
	preload("res://store/8.png"),
	preload("res://store/9.png"),
	preload("res://store/9.5.png"),
	preload("res://store/10.png"),
	preload("res://store/11.png"),
	preload("res://store/12.png"),
	preload("res://store/13.png"),
	preload("res://store/14.png"),
	preload("res://store/15.png"),
	preload("res://store/15.5.png"),
	preload("res://store/16.png"),
	preload("res://store/17.png"),
	preload("res://store/18.png"),
	preload("res://store/19.png"),
	preload("res://store/20.png"),
	preload("res://store/21.png"),
	preload("res://store/22.png"),
	preload("res://store/23.png"),
	preload("res://store/24.png"),
	preload("res://store/25.png"),
	preload("res://store/25.5.png"),
	preload("res://store/26.png"),
	preload("res://store/27.png"),
	preload("res://store/28.png"),
	preload("res://store/29.png"),
	preload("res://store/30.png"),
	preload("res://store/31.png"),
	preload("res://store/32.png"),
]

const names = [
	"Weak Slap",
	"Weak Punch",
	"Weak Kick",
	"Comfort Cry",
	"Punch",
	"Double Slap",
	"Trick Kick",
	"Power Slap",
	"Roar",
	"Scrap Magic",
	"Bite",
	"Defend",
	"Phyche",
	"Meditate",
	"Double Punch",
	"Zombie Roar",
	"Doom Magic",
	"Legendary Slap",
	"Stomp",
	"Tackle",
	"Horror Combo",
	"Slam",
	"Heal",
	"Tactical Punch",
	"Maniac Scream",
	"Haymaker",
	"Hyper Boxing",
	"Thunder",
	"Body Slam",
	"Takedown",
	"Secret of Tibet",
	"Mega Punch",
	"Dive Takedown",
	"Wraith of Åmål",
	"Ancient Magic",
]


func init(new_index):
	$TextureRect.texture = ability_icons[new_index]
	$Label.text = names[new_index]
	index = new_index
	

func toggle_native():
	native = !native
	display_prize()

func display_prize():
	if native:
		$rate.text = str(prize)
	else:
		$rate.text = str(prize * LAMPORTS_PER_NATIVE)

func set_prize(new_prize):
	prize = new_prize
	display_prize()

func set_supply(amount):
	$amount.text = str(amount)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_buy_pressed():
	await get_node("/root/w3").trade_ability_token(index, false, native)


func _on_sell_pressed():
	await get_node("/root/w3").trade_ability_token(index, true, native)


func _on_merge_pressed():
	await get_node("/root/w3").merge_ability_tokens(index)


func _on_equip_pressed():
	await get_node("/root/w3").equip_ability_token(index)
