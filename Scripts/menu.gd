extends Control

#func _on_save_pressed() -> void:
#
#
#func _on_resume_pressed() -> void:
#
#func _on_quit_pressed() -> void:


func _on_save_pressed() -> void:
	Save.save_game_components()


func _on_resume_pressed() -> void:
	ScenesMenager.GoToResumeGame()


func _on_quit_pressed() -> void:
	Save.save_game_components()
	get_tree().quit()
