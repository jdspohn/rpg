extends CharacterBody3D

@onready var pivot: Node3D = %Pivot
@onready var input_name: LineEdit = %InputName
@onready var label_no_spaces: Label = %LabelNoSpaces
@onready var label_name_exists: Label = %LabelNameExists

@onready var button_create: Button = %ButtonCreate
@onready var button_back: Button = %ButtonBack

var save_path: String = "user://characters/character.json"
var character_name: String = "character"
var level: int = 1

func _ready() -> void:
	button_create.pressed.connect(_on_create_pressed)
	button_back.pressed.connect(_on_back_pressed)
	input_name.text_changed.connect(_on_text_changed)
	input_name.text_submitted.connect(_on_text_submitted)
	button_create.disabled = true
	label_no_spaces.visible = false
	label_name_exists.visible = false


func _physics_process(_delta: float) -> void:
	pass


func _rotate_character() -> void:
	pass


func _on_text_changed(new_text) -> void:
	label_no_spaces.visible = false
	label_name_exists.visible = false
	if input_name.text == "" or new_text.contains(" "):
		button_create.disabled = true
		if new_text.contains(" "):
			label_no_spaces.visible = true
	else:
		button_create.disabled = false


func _on_text_submitted(_input: String) -> void:
	_on_create_pressed()


func _on_create_pressed() -> void:
	if button_create.disabled == true:
		return
	if input_name.text == "" or input_name.text.contains(" "):
		return
	character_name = input_name.text
	var timestamp = _create_timestamp()
	save_path = str("user://characters/", timestamp, character_name, ".json")
	if FileAccess.file_exists(save_path):
		#TODO: wait 1 second?
		label_name_exists.visible = true
		return
	
	_create_character()
	get_tree().reload_current_scene()


func _create_timestamp() -> String:
	var timestamp = Time.get_datetime_string_from_system(false)
	var clean_timestamp = timestamp.replace("-", "").replace("T", "").replace(":", "")
	return clean_timestamp


func _create_character() -> void:
	# TODO: generate uuid
	print ("Creating character...")
	PlayerData.save_path_json = save_path
	PlayerData.character_name = character_name
	PlayerData.level = level
	PlayerData.save_player_data_json()


func _on_back_pressed() -> void:
	#TODO go back to character select
	get_tree().reload_current_scene()
