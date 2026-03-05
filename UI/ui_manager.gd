class_name UI_Manager
extends CanvasLayer

signal create_lobby_requested
signal join_lobby_requested

@export var main_menu : MainMenu
@export var mode_select : ModeSelect

func _ready() -> void:
	main_menu._multiplayer_button_pressed.connect(_show_mode_select)
	mode_select.create_lobby_pressed.connect(_create_lobby)
	mode_select.join_lobby_pressed.connect(_join_lobby)

func _create_lobby() -> void:
	_hide_all_ui()
	create_lobby_requested.emit()

func _join_lobby() -> void:
	_hide_all_ui()
	join_lobby_requested.emit()

func _show_mode_select() -> void:
	for child in get_children():
		if child is not TextureRect:
			child.hide()
	mode_select.show()

func _hide_all_ui() -> void:
	for child in get_children():
		child.hide()
