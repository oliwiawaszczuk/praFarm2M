extends Control

func _on_time_day_money_container_tree_entered() -> void:
	TimeMenager.days_label = $TimeDayMoneyContainer/days
	TimeMenager.hour_label = $TimeDayMoneyContainer/hour
	TimeMenager.time_of_day_sprite = $TimeDayMoneyContainer/time_of_day
	ScenesMenager.PauseButton = $TimeDayMoneyContainer/pause


func _on_pause_pressed() -> void:
	ScenesMenager.TogglePause()
