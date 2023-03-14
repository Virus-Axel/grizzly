extends Node

var ID = "Gb8JJHRC7jrhnBQHJYxabPnKgKjj1RU1A7SB4iwchkeQ"
const ATOKEN = "ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL";
const TOKEN = "TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb";

#const MPL_TOKEN = "6sk5uQWhBTwWN2tLzLpE4jDD9rRd8H6ucQgAjocWkTcm";
const MPL_TOKEN = "metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s";

# On localhost
#const BANK_ID = "ANdidaLBCN3KrDFyraGtPVQhpaQr2oAqpPqN2DJL4CXv";
#const ARENA_ID = "5YDuhr5AWq6JT7ZtWioX5ynkt4t8y3c2ZDp6X22uyMkj"

# On testnet
const ARENA_ID = "BF8qnnYyoACeJwn8gAC8GbUpwH4scjved9B7wmpbyPtD"
const BANK_ID = "HbdhoAtFHfM8XuiHrMviJmynUvWnypGcs8o63wxGKSvp"

const SYSTEM_PROGRAM = "11111111111111111111111111111111"
const URL = "https://api.testnet.solana.com"
#const URL = "http://127.0.0.1:8899"

const APP_URL = "https%3A%2F%2Faxel.app"
const PHANTOM_CONNECT_URL = "https://phantom.app/ul/v1/connect"
const PHANTOM_SIGN_TRANSACTION_URL = "https://phantom.app/ul/v1/signAndSendTransaction"
#const REDIRECTION_LINK = "redirect_link%3Dhttps%3A%2F%2Faxel.app%3A%2F%2FonPhantomConnected"
const REDIRECTION_LINK = "client%3A%2F%2Faxel.app%2F"

const CLUSTER = "testnet"
#const CLUSTER = "localhost"
const USE_PHANTOM = true

# testnet accs
const NATIVE_MINT = "5pye17dQFdD7txTYm6b6XJDsKe7SSQvTxNxYmpHx72ww"

#const NATIVE_MINT = "ABoFjoNoA5b2CM2iKzYE8RttpWgSwY7ZDnvWpaTg3igA"
const ABILITY_MINTS = [
	"4UZLhgUBTTP1JWmnVYgPhiTyjtBDq2jDpbHDBPZxsbfx",
	"7eu7BrtQjRrT1hwFeztyqePG1iYhpzx5rdUmR5SHUCL",
	"6WEPfubN443TJ4tr8z2SsP8f3o1eXRzn4Wv2X2ykY4JX",
	"5NEahKsQjYAUsR3uQEZPsP5rBKmKr3Ne1TQmPDqh7Pu9",
	"9tVYuvgbKpdVs3FofhsN751bRyJndqTCzAjCBs5MxktA",
	"4Hkus2pJaB81GZ75DraRbXbsvFpAcgGH7iBCyhknnTTH",
	"Bos7CMvfJczYFGDR53isRGWYnj1AxFeikZxDzpPVnFme",
	"EtvYT2eghcvBv4yMiYfoGHyrRcUx7g4U1HDioyuwPkbb",
	"61jiYk4NSpHKhZ4n61q2ABz2dWs6Ruj7hXSwT9HAcNdz",
	"HtTEoLm2TFYDp7hiRhJ615hGPzM9rTtXaeprMXh9cfYa",
	"4jCJSYai4Meo5JbeSSWBhweVwz3ay5F78A6sf2pHLS8J",
	"AZNq12qBUgpH6f6NFtxaYcVsBayB9KTSKnxgTPD9MyP5",
	"D5AoHupuDSVqCDwqajJ2uEZL77yEj5U9Yc49gJZSiy4H",
	"kZycMK8pT73UKAfaUVMfWyjjZ9vWH4NkcJ5n6gbQrin",
	"HRkjejv2HJByKCjnUqeWKZEuMu65rSkt9tpmiQmGXFZV",
	"D23ZTLy894WbFg5Uu9mXtx57HBADDMYWZ1tEg3hjb44o",
	"3a1b7BYsU6AmSfaFwJ9NC3GVihW1M5abLChQHzD1emhN",
	"DRKgQtvu2C63nL966JxJkQZFav8jQuyjSWR4twZhthFa",
	"3MuBdzwCGZMBbFsCXYo42X8hoZYvtMkt6BWZe314WCbz",
	"Dgr9S4JXdRShnNzxrkhwRk9fwPZiffU1BDHUyw2u1m7D",
	"8cLyhh9eohWPix7bxbLCRKTNfSxsSE6fJJHYyrVQpTqJ",
	"5VLTC6jWabcJ5UAPdTnRjzY4xnCtN5g7QqHMZX1HPsWC",
	"A5TviRaUJbkjBk5xVbCe3M9UFknLAVkRYYFrg3HoMLCc",
	"DnUJHoQFezUABz8DDqnceEPWoynugvAwG7Bvimzixy9J",
	"ATx4C6rYYSKd3LiXpeo29ZtEjVv2fyg6ePjdeTM4DrLT",
	"HuY7vKZGktAaZuiEj3q93u1bn1TTxQ8tALDCc6ThCpJ4",
	"ATgqmtwNMZPKsGV4NWh7Fdvj7kGT4HapuPxW618MkBoG",
	"HHzbk3YQe9eY2nRtQeLHS4xmgaCCqwsGLgxKzDAY7vni",
	"8dNrjGAaTZMvLqPunRGBv4SsM3PJsxLqYWRAAAxca8nD",
	"5gHKVMcGuEHuSrNcnKVnnr8LjvokDUTVJZJXQVZEAa3i",
	"9SkiWcAZ8otwNqEhQszYfNJEfeS2ApWvWSEydNXbnPnH",
	"39hWEsayWBeRxLAno11Ah3BocMGw17jYLAyTNHapP69h",
#	"7n574mUAsNZfPfp8TL9R8DK1KmQNgcz6SGbwR2ZxkBR9",
#	"DmHDX68BzFQbjx9JChDseLF1Jqfb7z5XZwEbB7PELmcB",
#	"Abv16ZtBSGnGF3cRv2jgJgZGx9Sh5iM6vBozPUEGVcyi",
#	"9YqZjgRsFRtvfAgYXNNZGbtbwpvaDJwZsaJgq2huraYf",
#	"BPLzZt5iUJmLKsBS9mMaFvAq3xZaXAUHQ3iF5JcUvSRx",
#	"BhmUavxEXWDzA2y5DvJMYnbwxLoivhv6KBmgN6H3oAzX",
#	"G374HkQ4pjBbw6X9MXfuo3wQRAf8jQfo7bb33BGjKa6y",
#	"DJv6Ujs8yAnkLsjWDsqDK6LPJcdowuULgJn28Y2Utkst",
#	"GmQsuMcneAYVM9GrEsqRuBbjn3othbAy6W63mrUT3QKF",
	
]

const NO_ABILITIES: int = 32

var response_data = {}
var body_data
var signature

var arena_secret := PackedByteArray()

var diffie_secret_key = ""
var diffie_public_key = ""
var phantom_session = ""
var phantom_pubkey = ""
var shared_secret = ""
var wallet_key = ""
var nft_map = ""

signal connect_response
signal send_transaction_response
signal disconnected
signal bears_loaded
signal phantom_error

func int_from_array(arr: PackedByteArray) -> int:
	var ret: int = 0
	for i in arr.size():
		ret += arr[i] * (1 << (i))
	return ret

func int_to_array(val):
	var ret := PackedByteArray()
	ret.resize(4)
	ret.fill(0)
	ret[0] = val % 256
	ret[1] = (val / 256) % 256
	ret[2] = (val / 256 / 256) % 256
	ret[3] = (val / 256 / 256 / 256) % 256
	
	return ret

func get_random_nounce(length):
	var arr = PackedByteArray();
	arr.resize(length)
	for i in range(length):
		#arr[i] = randi() % 256
		arr[i] = 10;
	return arr

func keypair():
	$get_latest_block_hash.generateKeypair()
	return [$get_latest_block_hash.secret(), $get_latest_block_hash.pubkey()]

func get_query_params(url, params=3):
	var qmark = url.find('?')
	var eq_1 = url.find('=', qmark)
	var and_1 = url.find('&', eq_1)
	var shared_secret = url.substr(eq_1 + 1, and_1 - eq_1 - 1)
	var eq_2 = url.find('=', and_1)
	var and_2 = url.find('&', eq_2)
	var nounce
	if params == 3:
		nounce = url.substr(eq_2 + 1, and_2 - eq_2 - 1)
		var eq_3 = url.find('=', and_2)
		var data = url.substr(eq_3 + 1)
		return [shared_secret, nounce, data]
	else:
		nounce = url.substr(eq_2 + 1)
		return [shared_secret, nounce]

func phantom_send_transaction(encoded_transaction):
	var json_payload = {
		"transaction": encoded_transaction,
		"sendOptions": "",
		"session": phantom_session,
	}
	var payload = JSON.new().stringify(json_payload)
	print("payload is: ", payload)
	#var payload = "{\"transaction:\"" + encoded_transaction + "\",\"sendOptions\":\"\",\"session\":\"" + phantom_session + "\"}"
	print("send transaction payload: ", payload)
	
	print("encrypting with: ", phantom_pubkey)
	var nounce = get_random_nounce(24)
	#var encryption_data = $phantom_handler.encryptPhantomMessage(phantom_pubkey, payload, get_random_nounce(24))
	var cipher = $nacl.box(payload.to_utf8_buffer(), nounce, bs58.decode(phantom_pubkey), diffie_secret_key)
	var encryption_data = bs58.encode(cipher)
	print("encrypted payload is: ", encryption_data)
	print("maybe: ", encryption_data[-1])
	print("nounce is: ", bs58.encode(nounce))
	var phantom_string = PHANTOM_SIGN_TRANSACTION_URL + "?dapp_encryption_public_key=" + bs58.encode(diffie_public_key) + "&nonce=" + bs58.encode(nounce) + "&redirect_link=" + REDIRECTION_LINK + "&payload=" + encryption_data
	print(phantom_string)
	$get_latest_block_hash.request(phantom_string, ["Content-Type: application/json"], HTTPClient.METHOD_GET)
	await $get_latest_block_hash.request_completed
	OS.shell_open(phantom_string)
	$send_transaction_check.start()
	
func check_send_transaction_response():
	var got_url = false
	var url = ""

	if Engine.has_singleton('AppLinks'):
		url = Engine.get_singleton("AppLinks").getUrl()
		if url != "":
			got_url = true
		else:
			return false
	else:
		return false
	print("Phantom URL response: ", url)
	var params = get_query_params(url, 2)
	if url.find("&errorMessage") != -1:
		emit_signal("phantom_error", params[1])
		return true
	
	print("params: ", params)
	print("phantom pubkey: ", phantom_pubkey)
	print("diffie secret: ", diffie_secret_key)
	var decrypted_data = $nacl.box_open(bs58.decode(params[1]), bs58.decode(params[0]), bs58.decode(phantom_pubkey), diffie_secret_key).get_string_from_utf8()
	
	print("decrypted data is: ", decrypted_data)
	#var decrypted_data = $phantom_handler.decryptPhantomMessage(shared_secret, params[2], params[1])
	#var end_mark = decrypted_data.find('}')
	#var json_string = decrypted_data.substr(0, end_mark + 1)
	#var json = JSON.new()
	#json.parse(json_string)
	#print(json.get_data());
	emit_signal("send_transaction_response", decrypted_data)
	return true

func connect_phantom_wallet():
	var encryption_keys = $nacl.box_keypair()
	if encryption_keys.size() == 0:
		print("no keys")
		return
	print("secret key: ", encryption_keys[0])
	print("public key: ", encryption_keys[1])
	diffie_secret_key = encryption_keys[0]
	diffie_public_key = encryption_keys[1]
	var phantom_string = PHANTOM_CONNECT_URL + "?app_url=" + APP_URL + "&dapp_encryption_public_key=" + bs58.encode(encryption_keys[1]) + "&redirect_link=" + REDIRECTION_LINK + "&cluster=" + CLUSTER
	print(phantom_string)
	$get_latest_block_hash.request(phantom_string, [], HTTPClient.METHOD_GET)
	await $get_latest_block_hash.request_completed
	OS.shell_open(phantom_string)
	$connect_check.start()
	
func check_connect_response():
	var got_url = false
	var url = ""

	if Engine.has_singleton('AppLinks'):
		url = Engine.get_singleton("AppLinks").getUrl()
		if url != "":
			got_url = true
		else:
			return false
	else:
		return false

	print("Phantom URL response: ", url)
	var params = get_query_params(url)
	phantom_pubkey = params[0]
	print("phantom encryption key: ", phantom_pubkey)
	#shared_secret = $phantom_handler.getSharedPubkey(params[0])
	#print("shared secret is: ", shared_secret)
	print("nounce is: ", params[1])
	print("data is: ", params[2])
	#var decrypted_data = $phantom_handler.decryptPhantomMessage(params[0], params[2], params[1])
	var decrypted_data = $nacl.box_open(bs58.decode(params[2]), bs58.decode(params[1]), bs58.decode(params[0]), diffie_secret_key).get_string_from_utf8()
	print("decrypted data is: ", decrypted_data)
	var end_mark = decrypted_data.find('}')
	var json_string = decrypted_data.substr(0, end_mark + 1)
	var json = JSON.new()
	if json.parse(json_string) == null:
		print("failed to parse data")
	else:
		print("json data: ", json.get_data())
		wallet_key = json.get_data()['public_key']
		$program_handler.setKeys(SYSTEM_PROGRAM, wallet_key, ID);
		phantom_session = json.get_data()['session'];
	
	emit_signal("connect_response")
	return true

func get_attributes_from_data(data):
	const ATTRIBUTE_OFFSET = 10 
	const NO_ATTRIBUTES = 8
	const BYTES_PER_ATTRIBUTE = 4
	var ret = PackedInt32Array()
	ret.resize(NO_ATTRIBUTES)
	for i in range(NO_ATTRIBUTES):
		var attribute: int = 0
		for j in range(BYTES_PER_ATTRIBUTE):
			attribute += data[ATTRIBUTE_OFFSET + i * BYTES_PER_ATTRIBUTE + j] << 8 * j
		ret[i] = attribute

	print(ret)
	return ret

func get_bear_data(key, commitment="finilized"):
	var body = JSON.new().stringify({
		"id":1,
		"jsonrpc":"2.0",
		"method":"getAccountInfo",
		"params":[
			key,
			{
				"encoding": "base64",
				"commitment": commitment,
			}
		],
	})
	
	var request_handler = HTTPRequest.new()
	add_child(request_handler)
	request_handler.request_completed.connect(Callable(self, "set_response_data"))
	var error = request_handler.request(URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	await request_handler.request_completed
	
	remove_child(request_handler)
	if response_data.has("result"):
		if response_data["result"]["value"] == null:
			print("value is null")
			return ""
		if response_data["result"]["value"].has("data"):
			return response_data["result"]["value"]["data"][0]
		else:
			return ""
	else:
		return await get_bear_data(key, commitment)

func get_mapping_from_mint(mint):
	print("Checking mint: ", mint)
	var ret = []
	var body = JSON.new().stringify({
		"id":1,
		"jsonrpc":"2.0",
		"method":"getProgramAccounts",
		"params":[
			ID,
			{
			"filters": [
				{
					"dataSize": 64
				},
				{
					"memcmp": {
						"offset": 0,
						"bytes": mint
					}
				},
			],
		},
	],})
	
	var error = $get_latest_block_hash.request(URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	await $get_latest_block_hash.request_completed
	if response_data['result'].size() == 0:
		emit_signal("disconnected")
		return []
	else:
		var mapping_pubkey = response_data['result'][0]['pubkey']
		var mapping_data = bs58.decode(response_data['result'][0]['account']['data'])
		return [bs58.encode(mapping_data.slice(0, 32)), bs58.encode(mapping_data.slice(32)), mapping_pubkey]

func get_nft_keys(owner):
	print("Getting token accounts for: ", owner)
	var ret = []
	var body = JSON.new().stringify({
		"id":1,
		"jsonrpc":"2.0",
		"method":"getTokenAccountsByOwner",
		"params":[
			owner,
			{
				"programId": TOKEN,
			}
			,
			{
				"encoding": "jsonParsed"
			}
		]
	})
	var error = $get_latest_block_hash.request(URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	await $get_latest_block_hash.request_completed
	print(response_data)
	if not response_data.has('result'):
		return []
	for account in response_data['result']['value']:
		var mint = account['account']['data']['parsed']['info']['mint']
		var mapping = await get_mapping_from_mint(mint)
		if mapping.size() == 3:
			ret.append(mapping)
	emit_signal("bears_loaded")
	return ret

func get_current_moveset():
	const AMOUNT_OF_ABILITIES = 32
	const EQUIPPED_TOKEN_LOCATION = 106 + AMOUNT_OF_ABILITIES
	const NO_EQUIPPED_TOKENS = 5
	var bear_data = await get_bear_data(nft_map[1])
	var decoded_data = bs64.decode(bear_data)
	var moveset := PackedByteArray()
	moveset.resize(NO_EQUIPPED_TOKENS)
	
	for i in range(NO_EQUIPPED_TOKENS):
		moveset[i] = decoded_data[EQUIPPED_TOKEN_LOCATION + i]
	
	var levels := PackedByteArray()
	levels.resize(NO_ABILITIES)
	
	for i in range(NO_ABILITIES):
		levels[i] = decoded_data[EQUIPPED_TOKEN_LOCATION - NO_ABILITIES + i]
	
	return [moveset, levels]

func send_transaction(transaction):
	var body = JSON.new().stringify({
		"id":1,
		"jsonrpc":"2.0",
		"method":"sendTransaction",
		"params":[
			transaction,
		]
	})
	var request_handler = HTTPRequest.new()
	add_child(request_handler)
	request_handler.request_completed.connect(Callable(self, "set_response_data"))
	
	var error = request_handler.request(URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	await request_handler.request_completed
	
	remove_child(request_handler)
	return response_data

func mint_nft(name):
	# PDA mint (NOT USED)
	#addExistingAccount("11111111111111111111111111111111", programId);
	
	# Mint acc
	#addAccount(4321, programId);
	#addExistingAccount("ERLQKy88Pt7JFXtA5GSjAFLcL2y8eaPvpJXVGqLCExrV", programId);
	print("adding signer")
	$program_handler.addNewSigner(); # NOTE: Adds two accounts (new signer + authority)
	
	# Token acc
	print("auth is: ", $program_handler.getAccountAt(2));
	var mint_acc = $program_handler.getAccountAt(1);
	$program_handler.addAssociatedTokenAccount(mint_acc, wallet_key);
	print("token acc: ", $program_handler.getAccountAt(3))
	print("mint acc: ", $program_handler.getAccountAt(1))
	#addExistingAccount("7aXHE95fx1jjRDJMcJJixKWUAqKqjnv34SE7mNMe8HfA", programId);
	
	# Rent acc
	$program_handler.addAccount(4322, ID);
	
	$program_handler.addExistingAccount(SYSTEM_PROGRAM, ID);
	$program_handler.addExistingAccount(TOKEN, ID, false, false);
	$program_handler.addExistingAccount(ATOKEN, ID, false, false);
	#addExistingAccount("metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s", programId, false, false);
	$program_handler.addExistingAccount(MPL_TOKEN, ID, false, false);
	
	# Metadata account
	$program_handler.addAssociatedMetaAccount(mint_acc, MPL_TOKEN, false);
	print("metadata: ", $program_handler.getAccountAt(9))
	
	# Metadata edition account
	$program_handler.addAssociatedMetaAccount(mint_acc, MPL_TOKEN, true);
	print("edition: ", $program_handler.getAccountAt(10))
	
	# Lastly the bank
	$program_handler.addExistingAccount(BANK_ID, ID);
	
	# mapping and grizzly
	$program_handler.addNewSigner()
	print("mapping: ", $program_handler.getAccountAt(12))
	$program_handler.addNewSigner()
	print("grizzly: ", $program_handler.getAccountAt(13))
	
	$program_handler.addExistingAccount(NATIVE_MINT, ID);
	$program_handler.addAssociatedTokenAccount(NATIVE_MINT, wallet_key);
	
	$program_handler.addExistingAccount(ID, ID, false, false);
	
	var native_token = $program_handler.getAccountAt(15);

	var send_data = PackedByteArray();
	if name.to_utf8_buffer().size() > 255:
		print("Name length is too long")
		return;
	send_data.resize(3)
	send_data[0] = 1
	send_data[1] = name.to_utf8_buffer().size()
	if await has_token_account(native_token):
		send_data[2] = 0
	else:
		send_data[2] = 1
	
	send_data.append_array(name.to_utf8_buffer())
	var latest_blockhash = await get_latest_block_hash()
	var transaction
	if not USE_PHANTOM:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, true)
		print(await send_transaction(transaction))
	else:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, false)

		print("transaction is: ", transaction)
	
		phantom_send_transaction(transaction)

	$program_handler.clearAccountVector();


func get_target_bear(bear):
	const TARGET_POSITION = 42
	const AB_POSITION = TARGET_POSITION + 48
	var bear_data = await get_bear_data(bear)
	var decoded_data = bs64.decode(bear_data)
	var target_bear = decoded_data.slice(TARGET_POSITION, TARGET_POSITION + 32)
	var target_pubkey = bs58.encode(target_bear)
	var AB = decoded_data.slice(AB_POSITION, AB_POSITION + 8)

	return [target_pubkey, AB]


func equip_ability_token(ability_index):
	var send_data = PackedByteArray();
	send_data.resize(3)
	send_data[0] = 4
	send_data[1] = 0
	send_data[2] = ability_index
	
	var nft_accounts = get_accounts_from_mint(nft_map[0])
	
	$program_handler.addExistingAccount(nft_map[0], ID)
	$program_handler.addNewSigner()
	
	$program_handler.addExistingAccount(nft_accounts[0], ID)
	$program_handler.addAccount(4322, ID);
	
	$program_handler.addExistingAccount(TOKEN, ID, false, false)
	$program_handler.addExistingAccount(ATOKEN, ID, false, false)
	$program_handler.addExistingAccount(nft_accounts[1], ID)

	$program_handler.addExistingAccount(nft_map[2], ID)
	$program_handler.addExistingAccount(nft_map[1], ID)

	# Ability mint
	$program_handler.addExistingAccount(ABILITY_MINTS[ability_index], ID)
	$program_handler.addAssociatedTokenAccount(ABILITY_MINTS[ability_index], wallet_key)

	$program_handler.addExistingAccount(SYSTEM_PROGRAM, ID)


	var latest_blockhash = await get_latest_block_hash()

	var transaction
	if not USE_PHANTOM:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, true)
		print(await send_transaction(transaction))
	else:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, false)

		print("transaction is: ", transaction)
	
		phantom_send_transaction(transaction)
		
	$program_handler.clearAccountVector();

func clear_bear_data():
	var send_data = PackedByteArray();
	send_data.resize(1)
	send_data[0] = 3
	
	$program_handler.addExistingAccount(nft_map[1], ID)
	$program_handler.addExistingAccount(ARENA_ID, ID)
	
	var latest_blockhash = await get_latest_block_hash()

	var transaction
	if not USE_PHANTOM:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, true)
		print(await send_transaction(transaction))
	else:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, false)

		print("transaction is: ", transaction)
	
		phantom_send_transaction(transaction)
		
	$program_handler.clearAccountVector();
	return true


func is_opponent_ready(bear):
	const TARGET_POSITION = 42
	const AB_POSITION = TARGET_POSITION + 48
	var bear_data = await get_bear_data(bear)
	var decoded_data = bs64.decode(bear_data)
	var target_bear = decoded_data.slice(TARGET_POSITION, TARGET_POSITION + 32)
	var target_pubkey = bs58.encode(target_bear)
	
	var opponent_data = await get_bear_data(target_pubkey)
	var decoded_opponent_data = bs64.decode(opponent_data)
	
	if decoded_opponent_data.size() == 0:
		return false
	
	print(target_pubkey)
	print("dat: ", decoded_data[0])
	print("opp: ", decoded_opponent_data[0])
	
	if target_pubkey != SYSTEM_PROGRAM and decoded_data[0] == 1 and decoded_opponent_data[0] == 2:
		return true
	else:
		return false


func reveal_secret():
	var send_data = PackedByteArray();
	var target_bear = await get_target_bear(nft_map[1])
	if target_bear[0] == SYSTEM_PROGRAM:
		return false

	send_data.resize(17)
	send_data[0] = 2
	
	for i in range(arena_secret.size()):
		send_data[9 + i] = arena_secret[i]
		
	for i in range(8):
		send_data[9 + i] = 1
	
	for i in range(target_bear[1].size()):
		send_data[1 + i] = target_bear[1][i]
		
	print(send_data)
	
	$program_handler.addExistingAccount(nft_map[2], ID)
	$program_handler.addExistingAccount(nft_map[0], ID)
	$program_handler.addExistingAccount(nft_map[1], ID)
	
	$program_handler.addExistingAccount(target_bear[0], ID)
	$program_handler.addExistingAccount(ARENA_ID, ID)
	
	var latest_blockhash = await get_latest_block_hash()

	var transaction
	if not USE_PHANTOM:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, true)
		print(await send_transaction(transaction))
	else:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, false)

		print("transaction is: ", transaction)
	
		phantom_send_transaction(transaction)
		
	$program_handler.clearAccountVector();
	return true


func create_ability_token():
	$program_handler.addNewSigner()
	
	var mint_account = $program_handler.getAccountAt(1)
	print("new mint: ", mint_account)
	
	$program_handler.addAssociatedTokenAccount(mint_account, wallet_key)
	$program_handler.addAccount(4322, ID);
	$program_handler.addExistingAccount(TOKEN, ID, false, false)
	$program_handler.addExistingAccount(SYSTEM_PROGRAM, ID)
	for i in range(5):
		print("Acc: ", $program_handler.getAccountAt(i))

	var send_data := PackedByteArray()
	send_data.resize(1)
	send_data[0] = 5

	var latest_blockhash = await get_latest_block_hash()

	var transaction
	if not USE_PHANTOM:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, true)
		print(await send_transaction(transaction))
	else:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, false)

		print("transaction is: ", transaction)
	
		phantom_send_transaction(transaction)
		
	$program_handler.clearAccountVector();

func battle(moveset):
	print("map: ", nft_map)
	var nft_accounts = get_accounts_from_mint(nft_map[0])
	
	$program_handler.addExistingAccount(nft_map[2], ID)
	$program_handler.addExistingAccount(nft_map[0], ID)
	
	$program_handler.addExistingAccount(nft_accounts[0], ID)
	$program_handler.addExistingAccount(nft_accounts[1], ID)
	
	# Grizzly
	$program_handler.addExistingAccount(nft_map[1], ID)
	$program_handler.addExistingAccount(ARENA_ID, ID)
	
	$program_handler.addNewSigner();
	
	# Native tokens
	$program_handler.addExistingAccount(NATIVE_MINT, ID)
	$program_handler.addAssociatedTokenAccount(NATIVE_MINT, wallet_key)
	
	$program_handler.addExistingAccount(SYSTEM_PROGRAM, ID, false, false)
	$program_handler.addExistingAccount(TOKEN, ID, false, false)
	$program_handler.addExistingAccount(ATOKEN, ID, false, false)
	$program_handler.addAccount(4322, ID);
	
	var bear_data = await get_bear_data(nft_map[1])
	var decoded_data = bs64.decode(bear_data)
	
	var has_ability_token = false
	
	if decoded_data[0] == 0 and decoded_data[90] != 0:
		$program_handler.addExistingAccount(ABILITY_MINTS[decoded_data[90] - 1], ID)
		$program_handler.addAssociatedTokenAccount(ABILITY_MINTS[decoded_data[90] - 1], wallet_key)

		if await has_token_account($program_handler.getAccountAt(16)):
			has_ability_token = true

	var challenging_bear = await get_challenging_bear()
	if challenging_bear != "":
		print("added ", challenging_bear)
		$program_handler.addExistingAccount(challenging_bear, ID)
	
	var latest_blockhash = await get_latest_block_hash()

	var send_data = PackedByteArray();
	var prime = $primes.primes[randi() % $primes.primes.size()]

	send_data.resize(231)
	send_data.fill(0)
	
	if has_ability_token:
		send_data[1] = 0
	else:
		send_data[1] = 1
	
	for i in range(moveset.size()):
		send_data[2 + i] = moveset[i]
	send_data[8] = randi_range(2, 10);
	var prime_array = int_to_array(prime)
	for i in range(4):
		send_data[15 + 1] = prime_array[i]
	
	var a_secret = randi()
	#var a_secret = 1000
	
	var secret_bytes = int_to_array(a_secret)
	
	var AB = int(fmod(pow(send_data[2], a_secret), prime))
	var AB_bytes = int_to_array(AB)
	
	for i in range(23, 27):
		
		send_data[i] = AB_bytes[i - 23]
		#send_data[i] = 1
	
	arena_secret = send_data.slice(23, 31)
	
	var transaction
	if not USE_PHANTOM:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, true)
		print(await send_transaction(transaction))
	else:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, false)

		print("transaction is: ", transaction)
	
		phantom_send_transaction(transaction)

	$program_handler.clearAccountVector();


func get_challenging_bear():
	var data = await get_bear_data(ARENA_ID)
	var decoded_data = bs64.decode(data)
	if decoded_data[0] == 1:
		return bs58.encode(decoded_data.slice(1, 33))
	else:
		return ""

func get_accounts_from_mint(mint):
	var accounts = [];
	
	# Token acc
	$program_handler.addAssociatedTokenAccount(mint, wallet_key);
	# Metadata account
	$program_handler.addAssociatedMetaAccount(mint, MPL_TOKEN, false);
	# Metadata edition account
	$program_handler.addAssociatedMetaAccount(mint, MPL_TOKEN, true);

	for i in range(1, 4):
		accounts.append($program_handler.getAccountAt(i));
	
	$program_handler.clearAccountVector();
	#print(accounts);
	return accounts;

# Called when the node enters the scene tree for the first time.
func _ready():
	$get_latest_block_hash.setUrl(URL)
	return;
	var keys_p = $phantom_handler.generateDiffiePubkey()
	var keys_m = $phantom_handler.generateDiffiePubkey()
	var sk = $phantom_handler.getSharedPubkey(keys_p[1])
	
	print(keys_p)
	print(keys_m)
	print(sk)
	
	var encrypt = $phantom_handler.encryptPhantomMessage(keys_p[1], "11111111111111111111111111111111111111111111111111111111111111111111", get_random_nounce(24))
	print(encrypt)
	print($phantom_handler.decryptPhantomMessage(sk, encrypt[1], encrypt[0]))
	#create_account(100)
	#var params = get_query_params("client://axel.app/?phantom_encryption_public_key=H1Q6Bpd77ekjmwZymUk5jJdnXidPT4hJ6HJW7PqsQ3pM&nonce=4ZS6M9q5Ph6c3FT9gPZtGxFv9K9YvRkMH&data=2TLWu3t38xAfSZshioaRPS9GMYjZEr2VX8zgrdJL1qppU99uJvHmZyVzeifRs8oeez1zr2PxHdhLjNpF1LAxi8aZn1APzTz8QJULM1sgMpygMhEKLBptm4YE22uYDJ5yDKd1oaMMCXjJ6nM1KYvJMP4GT1BrDL5LP4Giw2gZoNJiu6rU7yxLy7Qbm5pMwQANXCfjNkTEapB95PUMy6XudfAMvv53Cfrx63L3X9pKDtHvmfMgDBrk4ZRW9yMcw3pFauubMEpbCcrSr9J2vMSJPcoNXxx5hs6bLs5C3nXZ85Qy7feDHLuVkophBc4aD5K2G7ygJioSsWkx51HtGc5S2mnmpGdhMVp1HJXpFwWSFhV7m7bqiMLUC9o2pvwEcFiZWHJd9imWzNgeovjzL8bPtpeHjsAyFC2eS")
	#print(params)
	#var shared_secret = $phantom_handler.getSharedPubkey(params[0])
	#print($phantom_handler.decryptPhantomMessage(shared_secret, params[2], params[1]))
	return
	connect_phantom_wallet()
	#signup_for_battle()
	pass
	
func signup_for_battle_not_used():
	var blockhash = await get_latest_block_hash()

	$program_handler.generateKeypair()
	var publicKey = $program_handler.pubkey()
	var privateKey = $program_handler.secret()
	
	print(publicKey)
	print(privateKey)
	
	$program_handler.setKeys("8B5LAjwFNkB4jo3kZEmzn7QD57igRW7gJXNi9t2RNxaA", "GFvZnxPPaZCeiA2d6gNVyE9ffu7B3PbHjw5AvRgPaZo6", ID)
	var transaction_signature = $program_handler.getTransactionSignature(PackedByteArray(), blockhash)
	
	send_transaction(transaction_signature)
	await $get_latest_block_hash.request_completed
	print(response_data)
	pass # Replace with function body.

func create_account(account_size, pubkey=""):
	var blockhash = await get_latest_block_hash()

	$program_handler.generateKeypair()
	var publicKey = $program_handler.pubkey()
	var privateKey = $program_handler.secret()
	
	#$program_handler.setKeys("8B5LAjwFNkB4jo3kZEmzn7QD57igRW7gJXNi9t2RNxaA", "GFvZnxPPaZCeiA2d6gNVyE9ffu7B3PbHjw5AvRgPaZo6", ID)
	var transaction_signature = $program_handler.getCreateAccountSignature(account_size, blockhash)
	
	send_transaction(transaction_signature)
	await $get_latest_block_hash.request_completed
	print(response_data)
	return [privateKey, publicKey]


func get_token_account(mint):
	var body = JSON.new().stringify({
		"id":1,
		"jsonrpc":"2.0",
		"method":"getTokenAccountsByOwner",
		"params":[
			wallet_key,
			{
				"mint": mint
			},
			{
				"encoding": "jsonParsed"
			},
		]
	})
	var request_handler = HTTPRequest.new()
	request_handler.request_completed.connect(Callable(self, "set_response_data"))
	add_child(request_handler)
	var error = request_handler.request(URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	await request_handler.request_completed
	remove_child(request_handler)
	if response_data.has("error"):
		if response_data["error"]["code"] == 429:
			$http_wait_timer.start()
			await $http_wait_timer.timeout
			return await get_token_account(mint)

	#if not response_data["result"].has("value"):
	#	return ""

	if response_data["result"]["value"].size() != 1:
		return ""
	else:
		return response_data["result"]["value"][0]["pubkey"]

func get_ability_rates():
	var encoded_data = await get_bear_data(ARENA_ID)
	var decoded_data = await bs64.decode(encoded_data)
	
	var ret = []
	
	const RATES_OFFSET: int = 33
	for i in range(NO_ABILITIES):
		ret.push_back(int_from_array(decoded_data.slice(RATES_OFFSET + i * 8, RATES_OFFSET + 8 + i * 8)))
	
	return ret

func get_ability_balance(index):
	var token_account = await get_token_account(ABILITY_MINTS[index])
	if token_account == "":
		return 0
	
	var body = JSON.new().stringify({
		"id":1,
		"jsonrpc":"2.0",
		"method":"getTokenAccountBalance",
		"params":[
			token_account
		]
	})
	
	var request_handler = HTTPRequest.new()
	request_handler.request_completed.connect(Callable(self, "set_response_data"))
	
	add_child(request_handler)
	var error = request_handler.request(URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	await request_handler.request_completed
	
	remove_child(request_handler)
	return response_data["result"]["value"]["uiAmount"]

func get_native_balance():
	var token_account = await get_token_account(NATIVE_MINT)
	if token_account == "":
		return 0
	
	var body = JSON.new().stringify({
		"id":1,
		"jsonrpc":"2.0",
		"method":"getTokenAccountBalance",
		"params":[
			token_account
		]
	})
	var request_handler = HTTPRequest.new()
	request_handler.request_completed.connect(Callable(self, "set_response_data"))
	add_child(request_handler)
	var error = request_handler.request(URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	await request_handler.request_completed
	
	remove_child(request_handler)
	return response_data["result"]["value"]["uiAmount"]


func get_ability_tokens():
	var tokens := PackedInt32Array()
	tokens.resize(ABILITY_MINTS.size())
	for i in range(ABILITY_MINTS.size()):
		tokens[i] = await get_ability_balance(i)
		$http_wait_timer.start()
		await $http_wait_timer.timeout
	
	var bear_data = await get_bear_data(nft_map[1])
	var decoded_data = bs64.decode(bear_data)
	
	if decoded_data[90] != 0 and decoded_data[0] == 0:
		tokens[decoded_data[90] - 1] += 1
	
	return tokens


func get_latest_block_hash():
	var body = JSON.new().stringify({
		"id":1,
		"jsonrpc":"2.0",
		"method":"getLatestBlockhash",
		"params":[
			{
				"commitment":"finalized"
			}
		]
	})
	var request_handler = HTTPRequest.new()
	add_child(request_handler)
	request_handler.request_completed.connect(Callable(self, "set_response_data"))
	var error = request_handler.request(URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
	await request_handler.request_completed

	var latest_blockhash = response_data['result']['value']['blockhash']
	remove_child(request_handler)
	
	return latest_blockhash

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()

	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	print(response.headers["User-Agent"])


func _on_connect_check_timeout():
	print("checking connect")
	if check_connect_response():
		$connect_check.stop()
	pass # Replace with function body.


func _on_send_transaction_check_timeout():
	print("checking send transaction")
	if check_send_transaction_response():
		$send_transaction_check.stop()
	pass # Replace with function body.


func has_token_account(mint):
	if await get_bear_data(mint) == "":
		return false
	else:
		return true


func trade_ability_token(index, sell, native):
	var ability_accounts = get_accounts_from_mint(ABILITY_MINTS[index])
	
	$program_handler.addExistingAccount(nft_map[0], ID)
	$program_handler.addNewSigner()
	$program_handler.addAssociatedTokenAccount(nft_map[0], wallet_key)
	$program_handler.addAccount(4322, ID)
	
	$program_handler.addExistingAccount(TOKEN, ID, false, false)
	$program_handler.addExistingAccount(ATOKEN, ID, false, false)
	$program_handler.addAssociatedMetaAccount(nft_map[0], MPL_TOKEN, false);
	
	$program_handler.addExistingAccount(nft_map[2], ID)
	$program_handler.addExistingAccount(nft_map[1], ID)
	
	$program_handler.addExistingAccount(ABILITY_MINTS[index], ID)
	$program_handler.addAssociatedTokenAccount(ABILITY_MINTS[index], wallet_key)
	
	$program_handler.addExistingAccount(NATIVE_MINT, ID)
	$program_handler.addAssociatedTokenAccount(NATIVE_MINT, wallet_key)
	
	$program_handler.addExistingAccount(BANK_ID, ID)
	$program_handler.addExistingAccount(ARENA_ID, ID)
	
	$program_handler.addExistingAccount(SYSTEM_PROGRAM, ID, false, false)
	
	var send_data = PackedByteArray();

	send_data.resize(5)
	send_data[0] = 7
	if await has_token_account(ABILITY_MINTS[index]):
		send_data[1] = 0
	else:
		send_data[1] = 1
	send_data[2] = index
	if sell:
		send_data[3] = 0
	else:
		send_data[3] = 1
	
	if native:
		send_data[4] = 0
	else:
		send_data[4] = 1
		
	var latest_blockhash = await get_latest_block_hash()
	print("latest blockhash: ", latest_blockhash)
	
	var transaction
	if not USE_PHANTOM:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, true)
		print(await send_transaction(transaction))
	else:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, false)
		phantom_send_transaction(transaction)
		
	$program_handler.clearAccountVector();
	

func merge_ability_tokens(index):
	print(nft_map[1])
	$program_handler.addExistingAccount(nft_map[0], ID)
	$program_handler.addNewSigner()
	$program_handler.addAssociatedTokenAccount(nft_map[0], wallet_key)
	
	$program_handler.addAccount(4322, ID)
	
	$program_handler.addExistingAccount(TOKEN, ID, false, false)
	$program_handler.addExistingAccount(ATOKEN, ID, false, false)
	$program_handler.addAssociatedMetaAccount(nft_map[0], MPL_TOKEN, false);
	
	$program_handler.addExistingAccount(nft_map[2], ID)
	$program_handler.addExistingAccount(nft_map[1], ID)
	
	$program_handler.addExistingAccount(ABILITY_MINTS[index], ID)
	$program_handler.addAssociatedTokenAccount(ABILITY_MINTS[index], wallet_key)
	
	$program_handler.addExistingAccount(SYSTEM_PROGRAM, ID, false, false)
	
	var send_data = PackedByteArray();

	send_data.resize(3)
	send_data[0] = 6
	
	if await has_token_account(ABILITY_MINTS[index]):
		send_data[1] = 0
	else:
		send_data[1] = 1
	send_data[2] = index

	var latest_blockhash = await get_latest_block_hash()

	var transaction
	if not USE_PHANTOM:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, true)
		print(await send_transaction(transaction))
	else:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, false)
		phantom_send_transaction(transaction)
		
	$program_handler.clearAccountVector();
	

func set_response_data(result, response_code, headers, body):
	#print(result)
	#print(response_code)
	#print(headers)
	#print(body)
	body_data = body.get_string_from_utf8()
	#print(body_data)
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	response_data = json.get_data();
	var response = json.get_data()
	#print(response)
