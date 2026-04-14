class_name Player
extends CharacterBody3D

@onready var pivot: Node3D = %Pivot
@onready var camera_pivot: CameraController = %CameraPivot

var player_state

# Player Stats
var walk_speed: float = 2.0
var run_speed: float = 4.0
var sprint_speed: float = 6.0
var jump_impulse: float = 13.0
var fall_acceleration: float = 50.0

var move_direction := Vector3.ZERO
var move_speed: float

func _handle_ground_physics() -> void:
	velocity.x = move_direction.x * move_speed
	velocity.z = move_direction.z * move_speed

func _handle_air_physics(delta) -> void:
	velocity.y -= fall_acceleration * delta
	if move_direction:
		velocity.x = move_direction.x * move_speed
		velocity.z = move_direction.z * move_speed

func move_and_rotate(delta) -> void:
	if move_direction:
		move_direction = move_direction.rotated(Vector3.UP, camera_pivot.rotation.y)
		pivot.basis = Basis.looking_at(move_direction)
	if is_on_floor():
		if velocity.y != 0:
			velocity.y = 0
		_handle_ground_physics()
		if InputManager.is_jumping:
			velocity.y = jump_impulse
	else:
		_handle_air_physics(delta)
	move_and_slide()

func DefinePlayerState() -> void:
	# FIXME server side clock synchronization?
	player_state = {"T": Time.get_unix_time_from_system() * 1000, "P": global_position, "R": pivot.global_rotation[1]}
	Server.SendPlayerState(player_state)

func _physics_process(delta: float) -> void:
	move_direction = Vector3(InputManager.move_input.x, 0, InputManager.move_input.y).normalized()
	if InputManager.move_input.length() <= 0.4:
		move_speed = walk_speed
	else:
		move_speed = run_speed
	if InputManager.is_sprinting:
		move_speed = sprint_speed
	move_and_rotate.call_deferred(delta)
	# FIXME should this send only 20 times per second?
	if Engine.get_physics_frames() % 3 == 0:
		DefinePlayerState.call_deferred()
