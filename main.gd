extends Node3D

@export var ui_manager : UI_Manager
@export var level_parent: Node3D

func _ready() -> void:
	ui_manager.create_lobby_requested.connect(_on_create_lobby)
	ui_manager.join_lobby_requested.connect(_on_join_lobby)

func _on_create_lobby() -> void:
	NetworkHandler.start_server()
	
	var level = load("res://Levels/level_one.tscn")
	var level_one = level.instantiate()
	$LevelParent.add_child(level_one)

func _on_join_lobby() -> void:
	NetworkHandler.start_client()
	
