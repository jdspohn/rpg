extends Control

const LOCAL_SERVER = preload("uid://dipv7kbnkyh2k")
const WORLD = preload("uid://tb8k4ol1femj")
const PLAYER = preload("uid://dn85my2emfvu8")

@onready var button_start_game: Button = %ButtonStartGame
@onready var button_join_game: Button = %ButtonJoinGame

func _ready() -> void:
	button_start_game.pressed.connect(_host_game)
	button_join_game.pressed.connect(_join_game)

func _host_game() -> void:
	var local_server = LOCAL_SERVER.instantiate()
	get_tree().current_scene.add_child(local_server)

func _join_game() -> void:
	Server.create_client()
	var world = WORLD.instantiate()
	var player = PLAYER.instantiate()
	get_tree().current_scene.add_child(world)
	get_tree().current_scene.add_child(player)
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _test_message() -> void:
	Server.message.rpc()
