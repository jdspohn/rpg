extends Node

func create_client():
	# set up client
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client("localhost", 9393) # Connect to local server
	
	var client_api = MultiplayerAPI.create_default_interface()
	get_tree().set_multiplayer(client_api, get_path())
	multiplayer.multiplayer_peer = client_peer

@rpc("any_peer")
func message():
	print("Message from (%d): Hello (%d) " % [multiplayer.get_remote_sender_id(), multiplayer.get_unique_id()])
