extends Control

@onready var main = $"../.."

func _on_continue_pressed():
	main.pauseMenu()

func _on_exit_game_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
