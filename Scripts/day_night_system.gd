extends Node2D

var night_color: Color = Color.hex(0x2d064f) #
var day_color: Color = Color.hex(0xf6f5ff) #

var light: DirectionalLight2D
var hour_label: Label
var current_time: float = 7.0

func _ready():
	light = $"Light"
	hour_label = $"../MainCamera/CanvasLayer/HBoxContainer2/Hour"


func _process(delta):
	if !Global.is_paused:
		update_time(delta)
	update_hour_text()
	update_light_color()


func update_light_color():
	var color: Color
	
	# Przejścia między dniem a nocą
	if current_time >= 21.0 or current_time < 4.0:
		# Noc (21:00 - 4:00)
		if current_time >= 21.0:
			# Od 21:00 do 24:00
			var factor = (current_time - 21.0) / 3.0
			color = night_color.lerp(day_color, factor)
		else:
			# Od 00:00 do 4:00
			var factor = current_time / 4.0
			color = day_color.lerp(night_color, factor)
	else:
		# Dzień (4:00 - 21:00)
		if current_time >= 4.0 and current_time < 12.0:
			# Od 4:00 do 12:00
			var factor = (current_time - 4.0) / 8.0
			color = night_color.lerp(day_color, factor)
		else:
			# Od 12:00 do 21:00
			var factor = (current_time - 12.0) / 9.0
			color = day_color.lerp(night_color, factor)
	
	light.color = color

func update_hour_text():
	var hours = int(current_time)
	var minutes = int((current_time - hours) * 60)

	# Ręczne formatowanie godzin i minut, aby zawsze miały dwie cyfry
	var hours_str = str(hours)
	var minutes_str = str(minutes)

	if hours < 10:
		hours_str = "0" + hours_str

	if minutes < 10:
		minutes_str = "0" + minutes_str

	var formatted_time = hours_str + ":" + minutes_str
	
	#var hour_text = str(round(current_time)) + ":" + str(float(current_time)%.2f) + " - " + str(current_time)
	hour_label.text = "Day: " + str(Global.day_count) + " - " + formatted_time

func update_time(delta):
	current_time += delta / 60.0
	if current_time >= 24.0:
		Global.day_count += 1
		current_time = 0.0
	Global.hour = current_time
