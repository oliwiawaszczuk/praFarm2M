extends Node

var Menu: Control
var PauseButton: Button

func _input(event: InputEvent) -> void:
	if event is InputEventKey and !event.is_pressed():
		if event.keycode == KEY_Q:
			Save.save_game_components()
			get_tree().quit()
		if event.keycode == KEY_ESCAPE:
			if !Menu.is_visible_in_tree():
				GoToMenu()
			else:
				GoToResumeGame()

func GoToResumeGame():
	Global.CursorToTool()
	Menu.visible = false
	Global.is_paused = true 
	TogglePause()

func GoToMenu():
	Global.current_cursor = Global.CursorState.idle
	Global.ChangeCursor()
	Menu.visible = true
	Global.is_paused = false 
	TogglePause()

func TogglePause():
	Global.is_paused = !Global.is_paused
	if PauseButton:
		if Global.is_paused:
			PauseButton.icon = load("res://Assets/tools/paused.png")
		else:
			PauseButton.icon = load("res://Assets/tools/resumed.png")

## SETTING LABEL DAYS
#func _on_label_tree_entered() -> void:
	#print("days label entered")
	#$"Day".text = "Days: " + str(Global.day_count)
