extends Node
class_name crypto

const MAX_SMALL_PRIME = 50000

var primes = []

func small_prime():
	var map := PackedByteArray()
	map.resize(MAX_SMALL_PRIME)
	map.fill(1)
	for i in range(2, sqrt(MAX_SMALL_PRIME)):
		if map[i] == 1:
			var increment = 0
			while (pow(i, 2) + increment * i) < MAX_SMALL_PRIME:
				map[(pow(i, 2) + increment * i)] = false
				increment += 1
	for i in range(map.size()):
		if map[i]:
			primes.push_back(i)


# Called when the node enters the scene tree for the first time.
func _ready():
	small_prime()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
