extends CharacterBody3D

@onready var pivot: Node3D = %Pivot
@onready var camera_pivot: Node3D = %CameraPivot

var player_state
var menu_open = false

var camera_input: Vector2 = Vector2.ZERO
var gamepad_camera_input: Vector2 = Vector2.ZERO

var move_input: Vector2 = Vector2.ZERO
var move_direction: Vector3 = Vector3.ZERO
var move_speed: float = 0

func _physics_process(delta: float) -> void:
	if not menu_open:
		set_camera()
		if Input.is_action_just_pressed("start_menu"):
			get_node("/root/Main/StartMenu").open()
			menu_open = true
	
	move_and_rotate(delta)
	
	# FIXME should this send only 20 times per second?
	if Engine.get_physics_frames() % 3 == 0:
		DefinePlayerState.call_deferred()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_input.x += event.relative.y * Settings.mouse_sensitivity
		camera_input.y += event.relative.x * Settings.mouse_sensitivity


func set_camera() -> void:
	gamepad_camera_input = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	if gamepad_camera_input.length() > 0.1:
		camera_input.x += gamepad_camera_input.y * Settings.gamepad_sensitivity
		camera_input.y += gamepad_camera_input.x * Settings.gamepad_sensitivity
	camera_pivot.move_camera(camera_input)
	camera_input = Vector2.ZERO


func set_move_speed() -> void:
	if move_input.length() <= 0.4:
		move_speed = PlayerData.walk_speed
	else:
		move_speed = PlayerData.run_speed
	if Input.is_action_pressed("sprint"):
		move_speed = PlayerData.sprint_speed


func _handle_ground_physics() -> void:
	velocity.x = move_direction.x * move_speed
	velocity.z = move_direction.z * move_speed


func _handle_air_physics(delta) -> void:
	velocity.y -= PlayerData.fall_acceleration * delta
	if move_direction:
		velocity.x = move_direction.x * move_speed
		velocity.z = move_direction.z * move_speed


func move_and_rotate(delta) -> void:
	move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	move_direction = Vector3(move_input.x, 0, move_input.y).normalized()
	set_move_speed()
	if move_direction:
		move_direction = move_direction.rotated(Vector3.UP, camera_pivot.rotation.y)
		pivot.basis = Basis.looking_at(move_direction)
	if is_on_floor():
		if velocity.y != 0:
			velocity.y = 0
		_handle_ground_physics()
		if Input.is_action_just_pressed("jump"):
			velocity.y = PlayerData.jump_impulse
	else:
		_handle_air_physics(delta)
	move_and_slide()


func DefinePlayerState() -> void:
	# FIXME server side clock synchronization?
	player_state = {"T": Time.get_unix_time_from_system() * 1000, "P": global_position, "R": pivot.global_rotation[1]}
	Server.SendPlayerState(player_state)
