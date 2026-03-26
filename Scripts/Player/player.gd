class_name Player
extends CharacterBody3D

@onready var input_manager: InputManager = %InputManager

@onready var pivot: Node3D = %Pivot

var move_direction = Vector3.ZERO
var move_speed = 4.0

func _handle_ground_physics() -> void:
	velocity.x = move_direction.x * move_speed
	velocity.z = move_direction.z * move_speed

func _physics_process(delta: float) -> void:
	move_direction = Vector3(input_manager.move_input.x, 0, input_manager.move_input.y).normalized()
	if move_direction != Vector3.ZERO:
		%Pivot.basis = Basis.looking_at(move_direction)
	_handle_ground_physics()
	move_and_slide()
