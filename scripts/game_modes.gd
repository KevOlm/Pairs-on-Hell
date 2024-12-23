extends Control

func _on_start_4_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/table_4_4.tscn")

func _on_start_6_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/table_6_4.tscn")

func _on_start_8_5_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/table_8_5.tscn")
