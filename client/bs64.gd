extends Node
class_name bs64

const mapping = [
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/", "=",
]

static func decode(str: String) -> PackedByteArray:
	var ret = PackedByteArray()
	ret.resize(str.length() * 6 / 8)
	for i in range(str.to_utf8_buffer().size()):
		var val = int(mapping.find(str[i]))
		if str[i] == "=":
			break
		var index = ceil(float(i) * 6.0 / 8.0)
		var splash = val >> ((3 - (i % 4)) * 2)
		if splash != 0:
			ret[index - 1] += splash
		if index >= ret.size():
			break
		ret[index] += val << (2 + (i % 4) * 2)
	return ret.slice(0)
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
