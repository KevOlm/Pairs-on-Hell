extends Control

@onready var transition = $Transition

func _on_start_pressed() -> void:
	transition.play("new_animation")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_transition_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/table_4_4.tscn")

func _on_modes_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_modes.tscn")
