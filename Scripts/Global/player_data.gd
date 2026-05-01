extends Node

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
		KEY_CHARACTER_NAME: character_name,
		KEY_LEVEL: level
	}
	var err: Error = Filehandler.store_json_file(save_data, save_path_json, true)
	if err != OK:
		push_error("Could not save player_data (JSON): ", error_string(err))
