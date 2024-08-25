extends Node

var Menu_scene = load("res://Scenes/menu.tscn") as PackedScene
var Day_stats_scene = load("res://Scenes/day_stats.tscn") as PackedScene
var Tool_bar_scene = load("res://Scenes/tool_bar.tscn") as PackedScene
var Field_stats_scene = load("res://Scenes/field_stats.tscn") as PackedScene
var Seeds_eq_scene = load("res://Scenes/seeds_eq.tscn") as PackedScene

func _ready() -> void:
	# MENU
	ScenesMenager.Menu = Menu_scene.instantiate() as Control
	add_child(ScenesMenager.Menu)
	ScenesMenager.GoToMenu()
	
	# DAY STATS
	var Day_stats = Day_stats_scene.instantiate() as Control
	add_child(Day_stats)
	TimeMenager.update_days_label()
	
	# TOOL BAR
	var tool_bar = Tool_bar_scene.instantiate() as Control
	add_child(tool_bar)
	
	# FIELD STATS
	var field_stats = Field_stats_scene.instantiate() as Control
	add_child(field_stats)
	
	# SEEDS EQ
	ScenesMenager.Seeds_eq = Seeds_eq_scene.instantiate() as Control
	add_child(ScenesMenager.Seeds_eq)
	ScenesMenager.Seeds_eq.visible = false
