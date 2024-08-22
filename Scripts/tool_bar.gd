extends Control

var containers_tools: Array

func _ready() -> void:
	containers_tools = [
		$Tools/view,
		$Tools/edit,
		$Tools/place
	]
	set_visible_false_for_container_of_tools()
	$Tools/view.visible = true

func set_visible_false_for_container_of_tools():
	for container in containers_tools:
		container.visible = false

# --- BAR ---
func _on_view_pressed() -> void:
	set_visible_false_for_container_of_tools()
	$Tools/view.visible = true

func _on_edit_pressed() -> void:
	set_visible_false_for_container_of_tools()
	$Tools/edit.visible = true

func _on_place_pressed() -> void:
	set_visible_false_for_container_of_tools()
	$Tools/place.visible = true

# --- TOOLS ---
# VIEW
func _on_to_move_pressed() -> void:
	Global.ChangeTool(Global.Tools.to_move)

func _on_selecting_pressed() -> void:
	Global.ChangeTool(Global.Tools.selecting)

# PLACE
func _on_hoe_pressed() -> void:
	Global.ChangeTool(Global.Tools.hoe)
