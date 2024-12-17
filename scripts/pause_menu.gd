extends Control

@onready var main = $"../.."

func _on_continue_pressed():
	main.pauseMenu()

func _on_exit_game_pressed():
	get_tree().quit()
