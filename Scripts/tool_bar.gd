extends Control

var containers_tools: Array

func _ready() -> void:
	containers_tools = [
		$Tools/view,
		$Tools/edit,
		$Tools/field
	]
	set_visible_false_for_container_of_tools()
	$Tools/view.visible = true
	
	DisableAreas.busy_areas.append($busy_area)
	Global.seed_tool = $Tools/field/seed
	
	# cost
	$Tools/edit/hexagon/cost.text = str(Global.cost["hexagon"])

func set_visible_false_for_container_of_tools():
	for container in containers_tools:
		container.visible = false

func go_to_next_category():
	var index_of_visible: int = 0
	for container in containers_tools:
		if container.visible:
			index_of_visible = containers_tools.find(container)
			break
	if index_of_visible == len(containers_tools)-1:
		index_of_visible = 0
	else:
		index_of_visible += 1
	set_visible_false_for_container_of_tools()
	containers_tools[index_of_visible].visible = true
	set_category_label(containers_tools[index_of_visible].name.to_upper())

func _input(event: InputEvent) -> void:
	if event is InputEventKey and !event.is_pressed():
		if !ScenesMenager.Menu.visible:
			if event.keycode == KEY_TAB:
				go_to_next_category()

func set_category_label(name: String):
	$VBoxBar/Label.text = name

func set_tool_name_label(name: String):
	$Label.text = name

# --- BAR ---
func _on_view_pressed() -> void:
	set_visible_false_for_container_of_tools()
	$Tools/view.visible = true
	set_category_label("View")

func _on_edit_pressed() -> void:
	set_visible_false_for_container_of_tools()
	$Tools/edit.visible = true
	set_category_label("Edit")

func _on_field_pressed() -> void:
	set_visible_false_for_container_of_tools()
	$Tools/field.visible = true
	set_category_label("Field")

# --- TOOLS ---
# VIEW
func _on_to_move_pressed() -> void:
	Global.ChangeTool(Global.Tools.to_move)
	set_tool_name_label("Moving")

func _on_selecting_pressed() -> void:
	Global.ChangeTool(Global.Tools.selecting)
	set_tool_name_label("Selecting")


# EDIT


# FIELD
func _on_hoe_pressed() -> void:
	Global.ChangeTool(Global.Tools.hoe)
	set_tool_name_label("Plowing")

func _on_watering_can_pressed() -> void:
	Global.ChangeTool(Global.Tools.watering_can)
	set_tool_name_label("Watering")

func _on_seed_pressed() -> void:
	ScenesMenager.GoToSeedsEq()
	set_tool_name_label("Seeds")


func _on_hexagon_pressed() -> void:
	Global.ChangeTool(Global.Tools.placing)
	set_tool_name_label("Adding grass")


func _on_basket_pressed() -> void:
	Global.ChangeTool(Global.Tools.basket)
	set_tool_name_label("Collecting plants")


func _on_shovel_pressed() -> void:
	Global.ChangeTool(Global.Tools.shovel)
	set_tool_name_label("Shovel")
