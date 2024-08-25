extends Control

func _on_time_day_money_container_tree_entered() -> void:
	TimeMenager.days_label = $TimeDayMoneyContainer/days
	TimeMenager.hour_label = $TimeDayMoneyContainer/hour
	TimeMenager.time_of_day_sprite = $TimeDayMoneyContainer/time_of_day
	ScenesMenager.PauseButton = $TimeDayMoneyContainer/pause
	Global.money_label = $TimeDayMoneyContainer/money
	Global.add_money(0) # to load label
	DisableAreas.busy_areas.append($busy_area)

func _on_pause_pressed() -> void:
	ScenesMenager.TogglePause()
	Global.current_cursor = Global.CursorState.idle
	Global.ChangeCursor()


func _on_pause_mouse_exited() -> void:
	Global.CursorToTool()


func _on_pause_mouse_entered() -> void:
	Global.current_cursor = Global.CursorState.idle
	Global.ChangeCursor()
