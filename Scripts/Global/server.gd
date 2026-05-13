extends Node

var initializing: bool = false
var active: bool = false
var player_appearance_collection = {}

func create_client():
	# set up client
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client("localhost", 9393) # Connect to local server
	
	var client_api = MultiplayerAPI.create_default_interface()
	get_tree().set_multiplayer(client_api, get_path())
	multiplayer.multiplayer_peer = client_peer
	
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	print("Client created")

func _on_connected_to_server():
	initializing = true
	SendPlayerAppearance()

func _on_server_disconnected():
	leave_game()

func start_game():
	get_node("/root/Main").DestroyMainMenu()
	await get_node("/root/Main").LoadWorld()
	get_node("/root/Main").LoadPlayer()
	get_node("/root/Main").CreateStartMenu()
	active = true

func leave_game():
	initializing = false
	active = false
	player_appearance_collection = {}
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	multiplayer.connected_to_server.disconnect(_on_connected_to_server)
	multiplayer.server_disconnected.disconnect(_on_server_disconnected)
	get_tree().reload_current_scene()

@rpc("any_peer")
func spawn_new_player(id):
	var player_id = id
	get_node("/root/Main/World").SpawnNewPlayer(player_id)

@rpc("any_peer")
func despawn_player(id):
	var player_id = id
	get_node("/root/Main/World").DespawnPlayer(player_id)

func SendPlayerState(player_state):
	if active == true:
		ReceivePlayerState.rpc_id(1, player_state)

func SendPlayerAppearance():
	var player_appearance = [
		PlayerData.character_name
	]
	ReceivePlayerAppearance.rpc_id(1, player_appearance)


@rpc("any_peer", "reliable")
func ReceivePlayerAppearance(_player_appearance):
	pass


@rpc("any_peer", "reliable")
func ReceivePlayerAppearanceCollection(server_player_appearance_collection, player_id):
	player_appearance_collection = server_player_appearance_collection
	#FIXME could cause errors if this is sent from another source while a player is connecting 
	if Server.multiplayer.get_unique_id() == player_id and initializing == true:
		initializing = false
		start_game()


@rpc("any_peer", "unreliable")
func ReceivePlayerState(_player_state):
	pass


@rpc("any_peer", "unreliable")
func ReceiveWorldState(world_state):
	if active == true:
		get_node("/root/Main/World").UpdateWorldState(world_state)
