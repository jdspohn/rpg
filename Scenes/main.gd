extends Node

const MAIN_MENU = preload("uid://bjgp0m1mun3f4")
const LOCAL_SERVER = preload("uid://dipv7kbnkyh2k")
const WORLD = preload("uid://tb8k4ol1femj")
const PLAYER = preload("uid://dn85my2emfvu8")
const START_MENU = preload("uid://bemuyjbtmgwmc")

func _ready() -> void:
	CreateMainMenu()

func CreateMainMenu():
	var main_menu = MAIN_MENU.instantiate()
	main_menu.host_game_pressed.connect(HostGame)
	main_menu.join_game_pressed.connect(JoinGame)
	add_child(main_menu)

func HostGame():
	await CreateLocalServer()
	JoinGame()

func JoinGame():
	## FIXME check for server availability
	get_node("MainMenu").queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Server.create_client()

func CreateLocalServer():
	var local_server = LOCAL_SERVER.instantiate()
	add_sibling(local_server)

func CreateWorld():
	var world = WORLD.instantiate()
	add_child(world)

func CreatePlayer():
	var player = PLAYER.instantiate()
	add_child(player)

func CreateStartMenu():
	var start_menu = START_MENU.instantiate()
	start_menu.leave_game_pressed.connect(Server.leave_game)
	add_child(start_menu)
