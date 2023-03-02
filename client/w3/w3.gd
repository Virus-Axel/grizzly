extends Node

var ID = "Gb8JJHRC7jrhnBQHJYxabPnKgKjj1RU1A7SB4iwchkeQ"
const ATOKEN = "ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL";
const TOKEN = "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA";
const MPL_TOKEN = "6sk5uQWhBTwWN2tLzLpE4jDD9rRd8H6ucQgAjocWkTcm";
#const MPL_TOKEN = "metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s";
const BANK_ID = "ANdidaLBCN3KrDFyraGtPVQhpaQr2oAqpPqN2DJL4CXv";

const SYSTEM_PROGRAM = "11111111111111111111111111111111"

#const URL = "https://api.testnet.solana.com"
const URL = "http://127.0.0.1:8899"

const APP_URL = "https%3A%2F%2Faxel.app"
const PHANTOM_CONNECT_URL = "https://phantom.app/ul/v1/connect"
const PHANTOM_SIGN_TRANSACTION_URL = "https://phantom.app/ul/v1/signAndSendTransaction"
#const REDIRECTION_LINK = "redirect_link%3Dhttps%3A%2F%2Faxel.app%3A%2F%2FonPhantomConnected"
const REDIRECTION_LINK = "client%3A%2F%2Faxel.app%2F"

#const CLUSTER = "testnet"
const CLUSTER = "localhost"

var response_data
var body_data
var signature

var diffie_secret_key = ""
var diffie_public_key = ""
var phantom_session = ""
var phantom_pubkey = ""
var shared_secret = ""
var wallet_key = ""

signal connect_response
signal send_transaction_response
signal disconnected
signal bears_loaded
signal phantom_error

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

	return ret

func get_bear_data(key):
	var body = JSON.new().stringify({
		"id":1,
		"jsonrpc":"2.0",
		"method":"getAccountInfo",
		"params":[
			key,
			{
				"encoding": "base64",
			}
		],
	})
	
	var error = $get_latest_block_hash.request(URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	await $get_latest_block_hash.request_completed
	if response_data.has("result"):
		if response_data["result"]["value"] == null:
			print("value is null")
			return ""
		return response_data["result"]["value"]["data"][0]
	else:
		print(response_data)
		return ""

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
		var mapping_data = bs58.decode(response_data['result'][0]['account']['data'])
		return [bs58.encode(mapping_data.slice(0, 32)), bs58.encode(mapping_data.slice(32))]

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
		if mapping.size() == 2:
			ret.append(mapping)
	emit_signal("bears_loaded")
	return ret

func send_transaction(transaction):
	var body = JSON.new().stringify({
		"id":1,
		"jsonrpc":"2.0",
		"method":"sendTransaction",
		"params":[
			transaction,
		]
	})
	var error = $get_latest_block_hash.request(URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	await $get_latest_block_hash.request_completed
	return response_data

func mint_nft(owner, name):
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
	$program_handler.addAssociatedTokenAccount(mint_acc, owner);
	print("token acc: ", $program_handler.getAccountAt(3))
	print("mint acc: ", $program_handler.getAccountAt(1))
	#addExistingAccount("7aXHE95fx1jjRDJMcJJixKWUAqKqjnv34SE7mNMe8HfA", programId);
	
	# Rent acc
	$program_handler.addAccount(4322, ID);
	
	$program_handler.addExistingAccount("11111111111111111111111111111111", ID);
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
	$program_handler.addExistingAccount(ID, SYSTEM_PROGRAM);
	
	var send_data = PackedByteArray();
	if name.to_utf8_buffer().size() > 255:
		print("Name length is too long")
		return;
	send_data.resize(2)
	send_data[0] = 1
	send_data[1] = name.to_utf8_buffer().size()
	send_data.append_array(name.to_utf8_buffer())
	get_latest_block_hash()
	await $get_latest_block_hash.request_completed
	var latest_blockhash = response_data['result']['value']['blockhash']
	var transaction
	if CLUSTER == "localhost":
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, true)
		print(await send_transaction(transaction))
	else:
		transaction = $program_handler.getTransactionSignature(send_data, latest_blockhash, false)

		print("transaction is: ", transaction)
	
		phantom_send_transaction(transaction)

	$program_handler.clearAccountVector();

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
	
func signup_for_battle():
	get_latest_block_hash()
	await $get_latest_block_hash.request_completed
	var blockhash = response_data['result']['value']['blockhash']
	
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
	get_latest_block_hash()
	await $get_latest_block_hash.request_completed
	var blockhash = response_data['result']['value']['blockhash']
	
	$program_handler.generateKeypair()
	var publicKey = $program_handler.pubkey()
	var privateKey = $program_handler.secret()
	
	#$program_handler.setKeys("8B5LAjwFNkB4jo3kZEmzn7QD57igRW7gJXNi9t2RNxaA", "GFvZnxPPaZCeiA2d6gNVyE9ffu7B3PbHjw5AvRgPaZo6", ID)
	var transaction_signature = $program_handler.getCreateAccountSignature(account_size, blockhash)
	
	send_transaction(transaction_signature)
	await $get_latest_block_hash.request_completed
	print(response_data)
	return [privateKey, publicKey]


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
	var error = $get_latest_block_hash.request(URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	pass

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


func _on_get_latest_block_hash_request_completed(result, response_code, headers, body):
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
