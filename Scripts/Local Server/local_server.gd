extends Node

var player_state_collection = {}
var player_appearance_collection = {}
var host = 0

func _enter_tree() -> void:
	# set up server
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(9393, 10) # Port, Max Clients
	
	var server_api = MultiplayerAPI.create_default_interface()
	get_tree().set_multiplayer(server_api, get_path())
	multiplayer.multiplayer_peer = server_peer
	
	# set up signals
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	print("Server created")

func _on_peer_connected(player_id):
	if host == 0:
		host = player_id
	print(str(player_id) + " Connected")

func _on_peer_disconnected(player_id):
	print(str(player_id) + " Disconnected")
	player_state_collection.erase(player_id)
	player_appearance_collection.erase(player_id)
	despawn_player.rpc(player_id)
	## FIXME make a better way to check
	if player_id == host:
		_terminate_server()
	#if multiplayer.get_peers().size() < 1:
		#_terminate_server()

func _terminate_server():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	multiplayer.peer_connected.disconnect(_on_peer_connected)
	multiplayer.peer_disconnected.disconnect(_on_peer_disconnected)
	queue_free()


@rpc("any_peer", "reliable")
func ReceivePlayerAppearance(player_appearance):
	var player_id = multiplayer.get_remote_sender_id()
	player_appearance_collection[player_id] = player_appearance
	SendPlayerAppearanceCollection()


func SendPlayerAppearanceCollection():
	ReceivePlayerAppearanceCollection.rpc(player_appearance_collection)

@rpc("any_peer", "reliable")
func ReceivePlayerAppearanceCollection(_server_player_appearance_collection):
	pass


@rpc("any_peer", "unreliable")
func ReceivePlayerState(player_state):
	var player_id = multiplayer.get_remote_sender_id()
	if player_state_collection.has(player_id):
		if player_state_collection[player_id]["T"] < player_state["T"]:
			player_state_collection[player_id] = player_state
	else:
		player_state_collection[player_id] = player_state

func SendWorldState(world_state):
	ReceiveWorldState.rpc(world_state)

@rpc("any_peer")
func spawn_new_player(_id):
	pass

@rpc("any_peer")
func despawn_player(_id):
	pass

@rpc("any_peer", "unreliable")
func ReceiveWorldState(_world_state):
	pass
