extends Control

@onready var character_select: PanelContainer = %CharacterSelect
@onready var character_list: VBoxContainer = %CharacterList
@onready var button_create_character: Button = %ButtonCreateCharacter
@onready var button_delete_character: Button = %ButtonDeleteCharacter

@onready var world_select: HBoxContainer = %WorldSelect
@onready var button_start_game: Button = %ButtonStartGame
@onready var button_join_game: Button = %ButtonJoinGame

signal start_game_pressed(origin: String)
signal join_game_pressed(origin: String)
signal create_character_pressed(origin: String)

var player_save_files_dir: String = "user://characters"

func _ready() -> void:
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
		else:
			for file_path in player_save_files_json:
				var save_data: Dictionary = {}
				var err: Error = Filehandler.open_json_file(file_path, save_data)
				if err != OK:
					push_error("Could not load player data (JSON): ", error_string(err))
					continue
				
				err = PlayerData.verify_save_data_json(save_data)
				if err != OK:
					push_error("Invalid save file structure")
					continue
				
				var slot = player_save_files_json.find(file_path)
				_create_character_option(slot, save_data["save_path_json"], save_data["character_name"], int(save_data["level"]))
				print (save_data["character_name"])
			if character_list.has_node("0"):
				get_node("CharacterSelect/VBoxContainer/PanelContainer/CharacterList/0").pressed.emit()
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
		# TODO: add error handling
		print ("Error, cannot open dir")
	return player_save_files_json


func _create_character_option(slot, save_path, character_name, _level) -> void:
	var character_list_option = Button.new()
	character_list_option.name = str(slot)
	character_list_option.pressed.connect(_select_character.bind(save_path))
	character_list_option.text = str(slot, character_name)
	character_list.add_child(character_list_option)


func _select_character(save_path) -> void:
	print (save_path)


func _on_create_character_pressed() -> void:
	create_character_pressed.emit()


func _on_delete_character_pressed() -> void:
	pass


func _on_start_game_pressed() -> void:
	start_game_pressed.emit()


func _on_join_game_pressed() -> void:
	join_game_pressed.emit()
