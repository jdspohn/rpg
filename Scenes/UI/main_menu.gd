extends Control

const LOCAL_SERVER = preload("uid://dipv7kbnkyh2k")

@onready var button_start_game: Button = %ButtonStartGame
@onready var button_join_game: Button = %ButtonJoinGame
@onready var message_from_client: Button = %MessageFromClient

func _ready() -> void:
	button_start_game.pressed.connect(_host_game)
	button_join_game.pressed.connect(_join_game)
	message_from_client.pressed.connect(_test_message)

func _host_game() -> void:
	var local_server = LOCAL_SERVER.instantiate()
	get_tree().current_scene.add_child(local_server)

func _join_game() -> void:
	Server.create_client()

func _test_message() -> void:
	Server.message.rpc()
