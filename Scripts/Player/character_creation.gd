extends CharacterBody3D

@onready var pivot: Node3D = %Pivot
@onready var input_name: LineEdit = %InputName
@onready var label_no_spaces: Label = %LabelNoSpaces
@onready var label_name_exists: Label = %LabelNameExists

@onready var button_create: Button = %ButtonCreate
@onready var button_back: Button = %ButtonBack

var character_name: String
var save_path: String

func _ready() -> void:
	button_create.pressed.connect(_on_create_pressed)
	button_back.pressed.connect(_on_back_pressed)
	input_name.text_changed.connect(_on_text_changed)
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


func _on_create_pressed() -> void:
	if input_name.text == "" or input_name.text.contains(" "):
		return
	character_name = input_name.text
	save_path = str("user://save_files/", character_name, ".json")
	if FileAccess.file_exists(save_path):
		label_name_exists.visible = true
		return
	
	print (save_path)
	_create_character()
	#generate uuid
	#pass uuid and name to playerdata
	#playerdata.save()


func _create_character() -> void:
	PlayerData.save_path_json = save_path
	PlayerData.character_name = character_name
	PlayerData.level = 1
	PlayerData.save_player_data_json()


func _on_back_pressed() -> void:
	#FIXME go back to character select
	get_tree().reload_current_scene()
