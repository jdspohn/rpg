class_name Player
extends CharacterBody3D

@onready var input_manager: InputManager = %InputManager
@onready var pivot: Node3D = %Pivot
@onready var camera_pivot: CameraController = %CameraPivot

var move_direction = Vector3.ZERO
var move_speed = 4.0

func move_and_rotate() -> void:
	if move_direction != Vector3.ZERO:
		move_direction = move_direction.rotated(Vector3.UP, camera_pivot.rotation.y)
		pivot.basis = Basis.looking_at(move_direction)
	_handle_ground_physics()
	move_and_slide()

func _handle_ground_physics() -> void:
	velocity.x = move_direction.x * move_speed
	velocity.z = move_direction.z * move_speed

func _physics_process(_delta: float) -> void:
	move_direction = Vector3(input_manager.move_input.x, 0, input_manager.move_input.y).normalized()
	move_and_rotate.call_deferred()
