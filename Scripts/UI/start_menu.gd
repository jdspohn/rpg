extends Control

@onready var button_leave_game: Button = %ButtonLeaveGame

func _ready() -> void:
	button_leave_game.pressed.connect(Server.leave_game)
	InputManager.start_menu = false

func control_menu() -> void:
	visible = InputManager.start_menu
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
