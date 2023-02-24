extends Node
class_name Web3;

const ID = "1289JhmLHgUWFjiNoP89krWdtfDJPc73nB3jUTnUck4"
const SYSTEM_PROGRAM = "11111111111111111111111111111111"
const URL = "https://api.testnet.solana.com"
const APP_URL = "https%3A%2F%2Faxel.app"
const PHANTOM_URL = "https://phantom.app/ul/v1/connect"
#const REDIRECTION_LINK = "redirect_link%3Dhttps%3A%2F%2Faxel.app%3A%2F%2FonPhantomConnected"
const REDIRECTION_LINK = "client%3A%2F%2Faxel.app%2F"
const CLUSTER = "testnet"

var response_data
var body_data

func get_query_params(url):
	var qmark = url.find('?')
	var eq_1 = url.find('=', qmark)
	var and_1 = url.find('&', eq_1)
	var shared_secret = url.substr(eq_1 + 1, and_1 - eq_1 - 1)
	var eq_2 = url.find('=', and_1)
	var and_2 = url.find('&', eq_2)
	var nounce = url.substr(eq_2 + 1, and_2 - eq_2 - 1)
	var eq_3 = url.find('=', and_2)
	var data = url.substr(eq_3 + 1)
	return [shared_secret, nounce, data]

func connect_phantom_wallet():
	var encryption_keys = $phantom_handler.generateDiffiePubkey()
	if encryption_keys.size() == 0:
		print("no keys")
		return
	print("secret key: ", encryption_keys[0])
	print("public key: ", encryption_keys[1])
	var phantom_string = PHANTOM_URL + "?app_url=" + APP_URL + "&dapp_encryption_public_key=" + encryption_keys[1] + "&redirect_link=" + REDIRECTION_LINK + "&cluster=" + CLUSTER
	print(phantom_string)
	$get_latest_block_hash.request(phantom_string, [], HTTPClient.METHOD_GET)
	await $get_latest_block_hash.request_completed
	OS.shell_open(phantom_string)
	var got_url = false
	var url = ""
	while not got_url:
		if Engine.has_singleton('AppLinks'):
			url = Engine.get_singleton("AppLinks").getUrl()
			if url != "":
				got_url = true
			else:
				await get_tree().create_timer(0.5).timeout
	print("Phantom URL response: ", url)
	var params = get_query_params(url)
	var shared_secret = $phantom_handler.getSharedPubkey(params[0])
	print("shared secret is: ", shared_secret)
	print("nounce is: ", params[1])
	print("data is: ", params[2])
	var decrypted_data = $phantom_handler.decryptPhantomMessage(shared_secret, params[2], params[1])
	var end_mark = decrypted_data.find('}')
	var json = decrypted_data.substr(0, end_mark + 1)
	print(json);
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$get_latest_block_hash.setUrl(URL)
	#print($phantom_handler.decryptPhantomMessage("C4bTKdHW1AkgjQythRHr2vBSpSvsLxbKpzeb2a3TEuK6", "4uzhZEtsxYgWeGc21jdHun5tynwQhXtG9GRfK251MSxHAZQAtWrYSrYjLS6kSghwnFx5pLwAkuv8aaipx9tE4zcW8DjnUqLjwRqeyaNXeqZMEcJ4gbvbnLWw9Uj2BGAuYRMh92ErKbP8zxNUkRtCK2YkhjAZFSPB7pjsLpNbvLza4u7Ku4TmHTedKUEUm9ewrNMdkUiEBeemf5X8UvrDVNPL2A6pifE9GrZH9YMqP9WpYjmyocpv9XGiR78X8XuwmcupRi5CD6573UXgK4c5uoViPWuBZk4mnMM4mvW2zC7Kh76hp1LZnp2oQ6ieWHPPWVsyPYK1EE71m9D59hEq45zSkGJnr3MGqypwKEbLfQzm2MPjRHTKFHfXEh9cgCPTfjdKoTyE9Rs3Bzto9F9FBuent34KJDYVb", "PPisLSUJDDzyowz4Pk9hiTV9ZgZriXrdZ"))
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

func create_account(account_size):
	get_latest_block_hash()
	await $get_latest_block_hash.request_completed
	var blockhash = response_data['result']['value']['blockhash']
	
	$program_handler.generateKeypair()
	var publicKey = $program_handler.pubkey()
	var privateKey = $program_handler.secret()
	
	$program_handler.setKeys("8B5LAjwFNkB4jo3kZEmzn7QD57igRW7gJXNi9t2RNxaA", "GFvZnxPPaZCeiA2d6gNVyE9ffu7B3PbHjw5AvRgPaZo6", ID)
	var transaction_signature = $program_handler.getCreateAccountSignature(account_size, blockhash)
	
	send_transaction(transaction_signature)
	await $get_latest_block_hash.request_completed
	print(response_data)
	pass # Replace with function body.


func send_transaction(transaction_signature):
	var body = JSON.new().stringify({
		"id":1,
		"jsonrpc":"2.0",
		"method":"sendTransaction",
		"params":[
			transaction_signature
		]
	})
	var error = $get_latest_block_hash.request(URL, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	pass

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
	print(result)
	print(response_code)
	print(headers)
	#print(body)
	body_data = body.get_string_from_utf8()
	print(body_data)
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	response_data = json.get_data();
	var response = json.get_data()
	print(response)
