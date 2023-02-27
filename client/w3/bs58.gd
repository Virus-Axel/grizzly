extends Node
class_name bs58

const base58map = [
	'1', '2', '3', '4', '5', '6', '7', '8',
	'9', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
	'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q',
	'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y',
	'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g',
	'h', 'i', 'j', 'k', 'm', 'n', 'o', 'p',
	'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
	'y', 'z' ];

const ALPHABET_MAP = [
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255,  0,  1,  2,  3,  4,  5,  6,  7,  8, 255, 255, 255, 255, 255, 255,
	255,  9, 10, 11, 12, 13, 14, 15, 16, 255, 17, 18, 19, 20, 21, 255,
	22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 255, 255, 255, 255, 255,
	255, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 255, 44, 45, 46,
	47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

static func encode(bytes: PackedByteArray) -> String:
	var encoded = PackedByteArray()
	encoded.resize((bytes.size() * 138 / 100) + 1)
	var digit_size = 1
	for i in range(bytes.size()):
		var carry = int(bytes[i])
		for j in range(digit_size):
			carry = carry + int(encoded[j] << 8);
			encoded[j] = (carry % 58) % 256;
			carry /= 58;
		while carry:
			encoded[digit_size] = (carry % 58) % 256;
			digit_size += 1
			carry /= 58
	var result: String;
	for i in range(bytes.size() - 1):
		if bytes[i]:
			break
		result += base58map[0];
	for i in range(digit_size):
		result += (base58map[encoded[digit_size - 1 - i]]);
	return result


static func decode(str: String) -> PackedByteArray:
	var result = PackedByteArray()
	result.resize(str.length() * 2)
	result[0] = 0;
	var resultlen = 1;
	for i in range(str.length()):
		var carry = ALPHABET_MAP[str.to_utf8_buffer()[i]];
		if (carry == -1):
			return [];
		for j in range(resultlen):
			carry += (result[j]) * 58;
			result[j] = (carry & 0xff) % 256;
			carry = carry >> 8;

		while (carry > 0):
			result[resultlen] = carry & 0xff
			resultlen += 1
			carry = carry >> 8

	for i in range(str.length()):
		if str[i] != '1':
			break
		result[resultlen] = 0;
		resultlen += 1

	var i = resultlen - 1
	var z = (resultlen >> 1) + (resultlen & 1)
	while(i >= z):
		var k = result[i];
		result[i] = result[resultlen - i - 1];
		result[resultlen - i - 1] = k;
		i -= 1
	return result.slice(0, resultlen)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
