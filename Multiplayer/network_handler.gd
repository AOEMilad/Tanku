extends Node

const PLAYER = preload("res://Tank/tank.tscn")
const PORT: int = 8080
const IP_ADDRESS: String = "127.0.0.1"

var enet_peer := ENetMultiplayerPeer.new()

func start_server() -> void:
	print("NetworkHandler: Start Server")
	var error = enet_peer.create_server(PORT, 8) # Max 8 players
	if error != OK:
		print("Failed to host: ", error)
		return
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	print("Server started on port ", PORT)

func add_player(peer_id: int):
	if peer_id == 1:
		return
	
	print("NEW PLAYER: ", str(peer_id))
	var new_player = PLAYER.instantiate()
	new_player.name = str(peer_id)
	#new_player.set_multiplayer_authority(peer_id)
	#print(get_tree().current_scene.get_node("LevelParent").get_node("LevelOne"))
	get_tree().current_scene.add_child(new_player, true)


func start_client() -> void:
	print("NetworkHandler: Start Client")
	var error = enet_peer.create_client(IP_ADDRESS, PORT)
	if error != OK:
		print("Failed to join: ", error)
		return
	
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.multiplayer_peer = enet_peer
	print("Connecting to server...")

func remove_player(peer_id):
	if peer_id == 1:
		leave_server()
	
	var players: Array[Node] = get_tree().get_nodes_in_group("Players")
	var player_to_remove = players.find_custom(func(item): return item.name == str(peer_id))
	if player_to_remove != -1:
		players[player_to_remove].queue_free()

func leave_server():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	clean_up_signals()
	get_tree().reload_current_scene()

func clean_up_signals():
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(remove_player)
	multiplayer.connected_to_server.disconnect(_on_connected_to_server)
	

func _on_connected_to_server():
	add_player(multiplayer.get_unique_id())
