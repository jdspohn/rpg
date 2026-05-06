extends Node

const KEY_SAVE_PATH_JSON: String = "save_path_json"
const KEY_CHARACTER_NAME: String = "character_name"
const KEY_LEVEL: String = "level"

# Player ID
var character_name: String

# Player Stats
var level: int = 1
var walk_speed: float = 2.0
var run_speed: float = 4.0
var sprint_speed: float = 6.0
var jump_impulse: float = 13.0
var fall_acceleration: float = 50.0

var save_path_json: String = "user://save_files/character.json"


func save_player_data_json() -> void:
	var save_data: Dictionary = {
		KEY_SAVE_PATH_JSON: save_path_json,
		KEY_CHARACTER_NAME: character_name,
		KEY_LEVEL: level
	}
	var err: Error = Filehandler.store_json_file(save_data, save_path_json, true)
	if err != OK:
		push_error("Could not save player data (JSON): ", error_string(err))


func load_player_data_json() -> void:
	var save_data: Dictionary = {}
	var err: Error = Filehandler.open_json_file(save_path_json, save_data)
	if err != OK:
		push_error("Could not load player data (JSON): ", error_string(err))
		return
	
	err = verify_save_data_json(save_data)
	if err != OK:
		push_error("Invalid save file structure")
		return
	
	save_path_json = save_data[KEY_SAVE_PATH_JSON]
	character_name = save_data[KEY_CHARACTER_NAME]
	level = save_data[KEY_LEVEL]


func verify_save_data_json(save_data: Dictionary) -> Error:
	if not save_data.has(KEY_SAVE_PATH_JSON):
		return ERR_DOES_NOT_EXIST
	if not save_data.has(KEY_CHARACTER_NAME):
		return ERR_DOES_NOT_EXIST
	if not save_data.has(KEY_LEVEL):
		return ERR_DOES_NOT_EXIST
	return OK
