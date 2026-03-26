class_name InputManager
extends Node3D

@export_range(0.0, 0.01) var mouse_sensitivity = 0.005
@export_range(0.0, 0.1) var gamepad_sensitivity = 0.06

var move_input = Vector2.ZERO
var camera_input = Vector2.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta: float) -> void:
	move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_input.x += event.relative.y * mouse_sensitivity
		camera_input.y += event.relative.x * mouse_sensitivity
