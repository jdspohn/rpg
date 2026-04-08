extends Node

func _enter_tree() -> void:
	# set up server
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(9393, 10) # Port, Max Clients
	
	var server_api = MultiplayerAPI.create_default_interface()
	get_tree().set_multiplayer(server_api, get_path())
	multiplayer.multiplayer_peer = server_peer
	
	# set up signals
	server_peer.peer_connected.connect(_on_peer_connected)
	server_peer.peer_disconnected.connect(_on_peer_disconnected)
	print("Server created")
	print(get_path())

func _on_peer_connected(id):
	print(str(id) + " Connected")
	spawn_new_player.rpc(id)

func _on_peer_disconnected(id):
	print(str(id) + " Disconnected")

@rpc("any_peer")
func message():
	print("Message from (%d): Hello (%d) " % [multiplayer.get_remote_sender_id(), multiplayer.get_unique_id()])

@rpc("any_peer")
func spawn_new_player(_id):
	pass
