extends Control

@onready var main_menu_select: VBoxContainer = %MainMenuSelect
@onready var button_start: Button = %ButtonStart
@onready var button_settings: Button = %ButtonSettings
@onready var button_quit: Button = %ButtonQuit

@onready var character_select: VBoxContainer = %CharacterSelect
@onready var button_create_character: Button = $CharacterSelect/HBoxContainer/ButtonCreateCharacter
@onready var button_delete_character: Button = $CharacterSelect/HBoxContainer/ButtonDeleteCharacter


@onready var world_select: HBoxContainer = %WorldSelect
@onready var button_start_game: Button = %ButtonStartGame
@onready var button_join_game: Button = %ButtonJoinGame

signal start_game_pressed(origin: String)
signal join_game_pressed(origin: String)
signal create_character_pressed(origin: String)


func _ready() -> void:
	button_start.pressed.connect(_on_start_pressed)
	button_settings.pressed.connect(_on_settings_pressed)
	button_quit.pressed.connect(_on_quit_pressed)
	button_create_character.pressed.connect(_on_create_character_pressed)
	button_start_game.pressed.connect(_on_start_game_pressed)
	button_join_game.pressed.connect(_on_join_game_pressed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


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
