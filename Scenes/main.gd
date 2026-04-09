extends Node

const PLAYER = preload("uid://dn85my2emfvu8")
const WORLD = preload("uid://tb8k4ol1femj")
const PLAYER_TEMPLATE = preload("uid://btqh8vh3rfwpb")

var last_world_state = 0

func CreateWorld():
	var world = WORLD.instantiate()
	get_tree().current_scene.add_child(world)

func CreatePlayer():
	var player = PLAYER.instantiate()
	get_tree().current_scene.add_child(player)

func SpawnNewPlayer(id):
	if Server.multiplayer.get_unique_id() == id:
		return
	if not has_node(str(id)):
		var new_player = PLAYER_TEMPLATE.instantiate()
		new_player.name = str(id)
		get_tree().current_scene.add_child(new_player)

func DespawnPlayer(id):
	get_node(str(id)).queue_free()

func UpdateWorldState(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state.erase("T")
		world_state.erase(Server.multiplayer.get_unique_id())
		for player in world_state.keys():
			if has_node(str(player)):
				get_node(str(player)).MovePlayer(world_state[player]["P"])
			else:
				print("Spawning player")
				SpawnNewPlayer(player)
