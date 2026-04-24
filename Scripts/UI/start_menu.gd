extends Control

@onready var button_leave_game: Button = %ButtonLeaveGame

signal leave_game_pressed()

func _ready() -> void:
	button_leave_game.pressed.connect(_on_leave_game_pressed)
	visible = false
	set_physics_process(false)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("start_menu"):
		close()

func _on_leave_game_pressed() -> void:
	leave_game_pressed.emit()

func open() -> void:
	set_physics_process(true)
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close() -> void:
	get_node("/root/Main/Player").menu_open = false
	set_physics_process(false)
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
