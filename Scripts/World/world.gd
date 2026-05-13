extends Node3D

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100

const PLAYER_TEMPLATE = preload("uid://btqh8vh3rfwpb")

func _physics_process(_delta: float) -> void:
	var render_time = (Time.get_unix_time_from_system() * 1000) - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
			world_state_buffer.remove_at(0)
		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
			for player in world_state_buffer[2].keys():
				if str(player) == "T":
					continue
				if player == Server.multiplayer.get_unique_id():
					continue
				if not world_state_buffer[1].has(player):
					continue
				if has_node(str(player)):
					var new_position = lerp(world_state_buffer[1][player]["P"], world_state_buffer[2][player]["P"], interpolation_factor)
					var new_rotation = world_state_buffer[1][player]["R"]
					# FIXME: causes rotation to flip because of wrong interpolation
					#var new_rotation = lerp(world_state_buffer[0][player]["R"], world_state_buffer[1][player]["R"], interpolation_factor)
					get_node(str(player)).MovePlayer(new_position, new_rotation)
				else:
					SpawnNewPlayer(player)
		elif render_time > world_state_buffer[1].T:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
			for player in world_state_buffer[1].keys():
				if str(player) == "T":
					continue
				if player == Server.multiplayer.get_unique_id():
					continue
				if not world_state_buffer[0].has(player):
					continue
				if has_node(str(player)):
					var position_delta = (world_state_buffer[1][player]["P"] - world_state_buffer[0][player]["P"])
					var new_position = world_state_buffer[1][player]["P"] + (position_delta * extrapolation_factor)
					var new_rotation = world_state_buffer[0][player]["R"]
					get_node(str(player)).MovePlayer(new_position, new_rotation)


func SpawnNewPlayer(id):
	if Server.multiplayer.get_unique_id() == id:
		return
	if not has_node(str(id)) and Server.player_appearance_collection.has(id):
		print("Spawning player ", id)
		# FIXME player should spawn at position if it exists
		var new_player = PLAYER_TEMPLATE.instantiate()
		new_player.name = str(id)
		add_child(new_player)
		new_player.SetAppearance(Server.player_appearance_collection[id])

func DespawnPlayer(id):
	await get_tree().create_timer(0.2).timeout
	if has_node(str(id)):
		get_node(str(id)).queue_free()

func UpdateWorldState(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)
