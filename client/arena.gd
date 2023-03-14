extends Node3D

const MAX_FIGHT_ROUNDS: int = 10
const FIGHT_DISTANCE: float = 0.6
const WALK_SPEED: float = 0.4

const animation_names = [
	"weak_slap",
	"weak_punch",
	"weak_kick",
	"comfort_cry",
	"punch"
]

var actions = []
var pos: int = 0

var bear1_standing := false
var bear2_standing := false

func eval_winner():
	print("winner ", actions.size())
	get_tree().change_scene_to_file("res://lobby/lobby.tscn")
	pass

func play_next_action():
	if actions.size() == pos:
		eval_winner()
		return
	if actions[pos] >= w3.NO_ABILITIES:
		play_action(actions[pos] - w3.NO_ABILITIES, false)
	else:
		play_action(actions[pos], true)
	pos += 1
	$calm_before_the_storm.start()

func play_action(action: int, your_turn: bool):
	var action_bear
	var other_bear
	if your_turn:
		action_bear = $bear
		other_bear = $bear2
		play_animation(animation_names[action], !your_turn)
	else:
		action_bear = $bear2
		other_bear = $bear
		play_animation(animation_names[action], !your_turn)



func set_loop(anim: String):
	var animation = $bear2.get_node("AnimationPlayer").get_animation(anim)
	animation.loop_mode = Animation.LOOP_LINEAR
	animation = $bear.get_node("AnimationPlayer").get_animation(anim)
	animation.loop_mode = Animation.LOOP_LINEAR

func play_animation(anim: String, opponent := false):
	if opponent:
		$other_animation_tree.set("parameters/" + anim + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		$your_animation_tree.set("parameters/" + anim + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func set_blend(value, opponent := false):
	if opponent:
		$other_animation_tree.set("parameters/stand_blend/blend_amount", value)
	else:
		$your_animation_tree.set("parameters/stand_blend/blend_amount", value)

func move_towards_center():
	$bear.position 

# Called when the node enters the scene tree for the first time.
func _ready():
	#actions.resize(MAX_FIGHT_ROUNDS)
	set_loop("idle001")
	set_loop("walk")
	
	var w3 = get_node("/root/w3")
	print(w3.nft_map[1])
	var bear_data = await w3.get_bear_data(w3.nft_map[1], "processed")
	var decoded_data = bs64.decode(bear_data)
	
	print("data: ", decoded_data)
	
	const ACTION_LIST_OFFSET: int = 74
	for i in range(MAX_FIGHT_ROUNDS):
		if ACTION_LIST_OFFSET + i == 90:
			continue
		if decoded_data[ACTION_LIST_OFFSET + i] >= 2 * w3.NO_ABILITIES:
			break
		actions.push_back(decoded_data[ACTION_LIST_OFFSET + i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not bear1_standing:
		#print($bear.position.x)
		if abs($bear.position.x - 1.6) < FIGHT_DISTANCE / 2.0:
			bear1_standing = true
			play_animation("stand")
		else:
			$bear.position.x += delta * WALK_SPEED
	if not bear2_standing:
		if abs($bear2.position.x - 1.6) < FIGHT_DISTANCE / 2.0:
			bear2_standing = true
			play_animation("stand", true)
		else:
			$bear2.position.x -= delta * WALK_SPEED
	pass



func _on_your_animation_tree_animation_finished(anim_name):
	if anim_name == "stand":
		set_blend(0.0)


func _on_other_animation_tree_animation_finished(anim_name):
	if anim_name == "stand":
		set_blend(0.0, true)
		$calm_before_the_storm.start()



func _on_calm_before_the_storm_timeout():
	play_next_action()
	pass # Replace with function body.
