extends Node

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
	get_node("/root/Main").CreateWorld()
	get_node("/root/Main").CreatePlayer()
	get_node("/root/Main").CreateStartMenu()

func _on_server_disconnected():
	leave_game()

func leave_game():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	multiplayer.connected_to_server.disconnect(_on_connected_to_server)
	multiplayer.server_disconnected.disconnect(_on_server_disconnected)
	get_tree().reload_current_scene()

@rpc("any_peer")
func spawn_new_player(id):
	var player_id = id
	get_node("/root/Main").SpawnNewPlayer(player_id)

@rpc("any_peer")
func despawn_player(id):
	var player_id = id
	get_node("/root/Main").DespawnPlayer(player_id)

func SendPlayerState(player_state):
	ReceivePlayerState.rpc_id(1, player_state)

@rpc("any_peer", "unreliable")
func ReceivePlayerState(_player_state):
	pass

@rpc("any_peer", "unreliable")
func ReceiveWorldState(world_state):
	get_node("/root/Main").UpdateWorldState(world_state)
