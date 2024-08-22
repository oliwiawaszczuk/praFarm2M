extends Node2D

var night_color: Color = Color.hex(0x2d064f)
var day_color: Color = Color.hex(0xf6f5ff)

var light: DirectionalLight2D

var days_label: Label
var hour_label: Label
var time_of_day_sprite: Sprite2D

func _ready():
	light = $"Light"
	#hour_label = $"../MainCamera/CanvasLayer/HBoxContainer2/Hour"

func _process(delta):
	if !Global.is_paused:
		update_time(delta)
	update_light_color()

func update_light_color():
	var color: Color
	
	if Global.current_time >= 21.0 or Global.current_time < 4.0:
		# Noc (21:00 - 4:00)
		if Global.current_time >= 21.0:
			# Od 21:00 do 24:00
			var factor = (Global.current_time - 21.0) / 3.0
			color = night_color.lerp(day_color, factor)
		else:
			# Od 00:00 do 4:00
			var factor = Global.current_time / 4.0
			color = day_color.lerp(night_color, factor)
	else:
		# Dzień (4:00 - 21:00)
		if Global.current_time >= 4.0 and Global.current_time < 12.0:
			# Od 4:00 do 12:00
			var factor = (Global.current_time - 4.0) / 8.0
			color = night_color.lerp(day_color, factor)
		else:
			# Od 12:00 do 21:00
			var factor = (Global.current_time - 12.0) / 9.0
			color = day_color.lerp(night_color, factor)
	
	#print("czas, ", Global.current_time, " time of day: ", Global.current_time_of_day)
	if Global.current_time >= 4.3 and Global.current_time < 10.0: # and Global.current_time_of_day != Global.time_of_day_state.SUNRISE:
		Global.current_time_of_day = Global.time_of_day_state.SUNRISE
		update_time_of_day_sprite()
	elif Global.current_time >= 10.0 and Global.current_time < 17.0 : #and Global.current_time_of_day != Global.time_of_day_state.MIDDAY:
		Global.current_time_of_day = Global.time_of_day_state.MIDDAY
		update_time_of_day_sprite()
	elif Global.current_time >= 17.0 and Global.current_time < 22.0: # and Global.current_time_of_day != Global.time_of_day_state.SUNSET:
		Global.current_time_of_day = Global.time_of_day_state.SUNSET
		update_time_of_day_sprite()
	else: # and Global.current_time_of_day != Global.time_of_day_state.MIDNIGHT:
		Global.current_time_of_day = Global.time_of_day_state.MIDNIGHT
		update_time_of_day_sprite()

	if light:
		light.color = color

func update_time(delta):
	Global.current_time += delta / 60.0
	update_time_label()
	if Global.current_time >= 24.0:
		Global.day_count += 1
		Global.current_time = 0.0
		update_days_label()

func get_formated_time():
	var hours = int(Global.current_time)
	var minutes = int((Global.current_time - hours) * 60)

	var hours_str = str(hours)
	var minutes_str = str(minutes)

	if hours < 10:
		hours_str = "0" + hours_str

	if minutes < 10:
		minutes_str = "0" + minutes_str

	var formatted_time = hours_str + ":" + minutes_str
	
	return formatted_time

func update_time_label():
	if hour_label:
		hour_label.text = get_formated_time()

func update_days_label():
	if days_label:
		days_label.text = "Day: " + str(Global.day_count)

func update_time_of_day_sprite():
	if time_of_day_sprite:
		var sprite: Texture = load("res://Assets/tools/" + str(Global.time_of_day_state.keys()[Global.current_time_of_day]).to_lower() + ".png") as Texture
		#print("godzina: ", Global.current_time, " na: ", str(Global.time_of_day_state.keys()[Global.current_time_of_day]).to_lower())
		time_of_day_sprite.texture = sprite
