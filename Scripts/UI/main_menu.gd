extends Control

@onready var button_start_game: Button = %ButtonStartGame
@onready var button_join_game: Button = %ButtonJoinGame

signal host_game_pressed(origin: String)
signal join_game_pressed(origin: String)

func _ready() -> void:
	button_start_game.pressed.connect(_on_host_game_pressed)
	button_join_game.pressed.connect(_on_join_game_pressed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_host_game_pressed() -> void:
	host_game_pressed.emit()

func _on_join_game_pressed() -> void:
	join_game_pressed.emit()
