extends Node

const PLAYER_TEMPLATE = preload("uid://btqh8vh3rfwpb")

func SpawnNewPlayer(id):
	if Server.multiplayer.get_unique_id() == id:
		return
	var new_player = PLAYER_TEMPLATE.instantiate()
	new_player.name = str(id)
	get_tree().current_scene.add_child(new_player)
