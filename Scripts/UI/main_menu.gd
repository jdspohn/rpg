extends Control

@onready var main_menu_select: VBoxContainer = %MainMenuSelect
@onready var button_start: Button = %ButtonStart
@onready var button_settings: Button = %ButtonSettings
@onready var button_quit: Button = %ButtonQuit

@onready var character_select: PanelContainer = %CharacterSelect
@onready var button_create_character: Button = %ButtonCreateCharacter
@onready var button_delete_character: Button = %ButtonDeleteCharacter

@onready var world_select: HBoxContainer = %WorldSelect
@onready var button_start_game: Button = %ButtonStartGame
@onready var button_join_game: Button = %ButtonJoinGame

signal start_game_pressed(origin: String)
signal join_game_pressed(origin: String)
signal create_character_pressed(origin: String)

var player_save_files_dir: String = "user://save_files"

func _ready() -> void:
	button_start.pressed.connect(_on_start_pressed)
	button_settings.pressed.connect(_on_settings_pressed)
	button_quit.pressed.connect(_on_quit_pressed)
	button_create_character.pressed.connect(_on_create_character_pressed)
	button_start_game.pressed.connect(_on_start_game_pressed)
	button_join_game.pressed.connect(_on_join_game_pressed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_load_character_list()


func _load_character_list() -> void:
	if DirAccess.dir_exists_absolute(player_save_files_dir):
		var player_save_files_json = _get_player_save_files_json()
		if player_save_files_json.is_empty():
			print ("no characters found")
		print (player_save_files_json)
	else:
		print ("cannot find dir")


func _get_player_save_files_json() -> Array:
	var player_save_files_json: Array = []
	var dir = DirAccess.open(player_save_files_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".json"):
				player_save_files_json.append(str(player_save_files_dir, "/", file_name))
			file_name = dir.get_next()
		
		dir.list_dir_end()
	else:
		print ("Error, cannot open dir")
	return player_save_files_json


func _on_start_pressed() -> void:
	main_menu_select.hide()
	character_select.show()


func _on_settings_pressed() -> void:
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_create_character_pressed() -> void:
	create_character_pressed.emit()

func _on_delete_character_pressed() -> void:
	pass

func _on_start_game_pressed() -> void:
	start_game_pressed.emit()


func _on_join_game_pressed() -> void:
	join_game_pressed.emit()
