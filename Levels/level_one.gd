extends Node3D

const PLAYER = preload("res://Tank/tank.tscn")

func _ready() -> void:
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(_on_peer_connected)

func _on_peer_connected(peer_id: int) -> void:
	spawn_player.rpc(peer_id)
	for player in $Players.get_children():
		spawn_player.rpc_id(peer_id, player.name.to_int())

@rpc("authority", "call_local", "reliable")
func spawn_player(peer_id: int) -> void:
	var new_player = PLAYER.instantiate()
	new_player.name = str(peer_id)
	new_player.set_multiplayer_authority(peer_id)
	$Players.add_child(new_player)
