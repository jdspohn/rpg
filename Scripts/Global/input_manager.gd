extends Node

@export_range(0.0, 0.01) var mouse_sensitivity = 0.005
@export_range(0.0, 0.1) var gamepad_sensitivity = 0.06

var move_input = Vector2.ZERO
var camera_input = Vector2.ZERO
var gamepad_camera_input = Vector2.ZERO
var is_sprinting = false
var is_jumping = false
var start_menu = false

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	# FIXME this is a bad way to do jump/sprint inputs
	is_sprinting = false
	is_jumping = false
	move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	gamepad_camera_input = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	if gamepad_camera_input.length() > 0.1:
		camera_input.x += gamepad_camera_input.y * gamepad_sensitivity
		camera_input.y += gamepad_camera_input.x * gamepad_sensitivity
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
	if Input.is_action_just_pressed("jump"):
		is_jumping = true
	if Input.is_action_just_pressed("start_menu") and get_tree().current_scene.has_node("StartMenu"):
		start_menu = !start_menu
		get_node("/root/Main/StartMenu").control_menu()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_input.x += event.relative.y * mouse_sensitivity
		camera_input.y += event.relative.x * mouse_sensitivity
