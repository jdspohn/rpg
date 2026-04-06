class_name CameraController
extends Node3D

@export_range(-90.0, 0.0, 0.01, "radians_as_degrees") var min_vertical_angle: float = -PI/2
@export_range(0.0, 90.0, 0.01, "radians_as_degrees") var max_vertical_angle: float = PI/4

func move_camera(camera_input: Vector2) -> void:
	rotation.x -= camera_input.x
	rotation.x = clampf(rotation.x, min_vertical_angle, max_vertical_angle)
	rotation.y -= camera_input.y
	rotation.y = wrapf(rotation.y, 0.0, TAU)

func _physics_process(_delta: float) -> void:
	move_camera(InputManager.camera_input)
	InputManager.camera_input = Vector2.ZERO
