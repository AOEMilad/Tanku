class_name ModeSelect
extends Control

signal create_lobby_pressed
signal join_lobby_pressed

@export var create_lobby : Button
@export var join_lobby : Button

func _ready() -> void:
	create_lobby.pressed.connect(func(): create_lobby_pressed.emit())
	join_lobby.pressed.connect(func(): join_lobby_pressed.emit())
