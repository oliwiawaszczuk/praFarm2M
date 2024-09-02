extends Control

func _on_save_pressed() -> void:
	Save.save_game_components()

func _on_resume_pressed() -> void:
	ScenesMenager.GoToResumeGame()

func _on_quit_pressed() -> void:
	Save.save_game_components()
	get_tree().quit()

func _on_sprite_2d_visibility_changed() -> void:
	if self.visible:
		update_text()


func update_text() -> void:
	$Day.text = "Day: " + str(Global.day_count) + "\nTime: " + TimeMenager.get_formated_time()
	$Plants.text = Global.return_seed_eq_as_string()
