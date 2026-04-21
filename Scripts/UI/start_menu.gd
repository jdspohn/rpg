extends Control

@onready var button_leave_game: Button = %ButtonLeaveGame

signal leave_game_pressed()

func _ready() -> void:
	button_leave_game.pressed.connect(_on_leave_game_pressed)
	InputManager.start_menu = false

func _on_leave_game_pressed() -> void:
	leave_game_pressed.emit()

func control_menu() -> void:
	visible = InputManager.start_menu
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
