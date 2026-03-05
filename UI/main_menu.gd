class_name MainMenu
extends Control

signal _singleplayer_button_pressed
signal _multiplayer_button_pressed
signal _quit_button_pressed

@export var singleplayer_button: Button
@export var multiplayer_button: Button
@export var quit_button: Button

func _ready() -> void:
	singleplayer_button.pressed.connect(func(): _singleplayer_button_pressed.emit())
	multiplayer_button.pressed.connect(func(): _multiplayer_button_pressed.emit())
	quit_button.pressed.connect(func(): _quit_button_pressed.emit())
