extends Node

const MAIN_MENU = preload("uid://bjgp0m1mun3f4")
const WORLD = preload("uid://tb8k4ol1femj")
const PLAYER = preload("uid://dn85my2emfvu8")
const START_MENU = preload("uid://bemuyjbtmgwmc")

func _ready() -> void:
	CreateMainMenu()

func CreateMainMenu():
	var main_menu = MAIN_MENU.instantiate()
	add_child(main_menu)

func CreateWorld():
	var world = WORLD.instantiate()
	add_child(world)

func CreatePlayer():
	var player = PLAYER.instantiate()
	add_child(player)

func CreateStartMenu():
	var start_menu = START_MENU.instantiate()
	add_child(start_menu)
