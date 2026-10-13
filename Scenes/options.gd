extends Control

@export var button_font: Font

const OUTLINE := Color("1b6ca8")
const NORMAL := Color("bfe9ff")
const HOVER := Color("e8fbff")
const PRESSED := Color("8fd3f5")

var title: Label


func _ready() -> void:
	for child in $options_box.get_children():
		if child is Button:
			_style_button(child)
		elif child.name == "options_title" and title == null:
			title = child as Label
		elif child is Label:
			_style_label(child)
		elif child is HSlider:
			_style_slider(child)
	_play_intro()


func _play_intro() -> void:
	var items: Array[Control] = []
	if title:
		items.append(title)
	for item in $options_box.get_children():
		items.append(item)

	# Hide everything right away so nothing flashes on screen.
	# (Scale is tiny instead of zero, which Godot dislikes.)
	for item in items:
		item.modulate.a = 0.0
		item.scale = Vector2(0.01, 0.01)

	# Wait one frame so the container has sized everything
	await get_tree().process_frame
	for item in items:
		item.pivot_offset = item.size / 2

	var delay := 0.2
	for item in items:
		var tween := create_tween().set_parallel(true)
		tween.tween_property(item, "modulate:a", 1.0, 0.3).set_delay(delay)
		tween.tween_property(item, "scale", Vector2.ONE, 0.7) \
			.set_delay(delay).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		if item == title:
			tween.finished.connect(_start_title_float)
		delay += 0.15


func _start_title_float() -> void:
	var pulse := create_tween().set_loops()
	pulse.tween_property(title, "scale", Vector2(1.05, 1.05), 1.5) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pulse.tween_property(title, "scale", Vector2.ONE, 1.5) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	var sway := create_tween().set_loops()
	sway.tween_property(title, "rotation_degrees", 2.0, 2.0) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	sway.tween_property(title, "rotation_degrees", -2.0, 2.0) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _make_style(fill: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.set_border_width_all(4)
	style.border_color = OUTLINE
	style.set_corner_radius_all(30)
	style.content_margin_left = 48
	style.content_margin_right = 48
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	style.shadow_color = Color(0.1, 0.3, 0.5, 0.35)
	style.shadow_size = 6
	style.shadow_offset = Vector2(0, 4)
	return style


func _style_button(button: Button) -> void:
	button.add_theme_stylebox_override("normal", _make_style(NORMAL))
	button.add_theme_stylebox_override("hover", _make_style(HOVER))
	button.add_theme_stylebox_override("pressed", _make_style(PRESSED))

	# Focus outline, used when navigating with keyboard or controller
	var focus := _make_style(Color.TRANSPARENT)
	focus.draw_center = false
	focus.shadow_size = 0
	focus.border_color = Color.WHITE
	button.add_theme_stylebox_override("focus", focus)

	if button_font:
		button.add_theme_font_override("font", button_font)
	button.add_theme_font_size_override("font_size", 40)
	for color_name in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		button.add_theme_color_override(color_name, OUTLINE)


func _style_slider(slider: HSlider) -> void:
	var empty = ImageTexture.new()
	for icon_name in ["grabber", "grabber_highlight", "grabber_pressed"]:
		slider.add_theme_icon_override(icon_name, empty)
	
	
	var base_style := StyleBoxFlat.new()
	base_style.bg_color = OUTLINE
	base_style.border_color = HOVER
	base_style.set_border_width_all(12)
	base_style.set_corner_radius_all(15)
	base_style.set_expand_margin_all(8)
	base_style.shadow_color = Color(0.1, 0.3, 0.5, 0.35)
	base_style.shadow_size = 6
	base_style.shadow_offset = Vector2(0, 4)
	slider.add_theme_stylebox_override("slider", base_style)
	
	var grabber_style := StyleBoxFlat.new()
	grabber_style.bg_color = OUTLINE.lightened(0.25)
	grabber_style.set_expand_margin(SIDE_TOP, 2)
	grabber_style.set_expand_margin(SIDE_BOTTOM, 2)
	grabber_style.set_corner_radius_all(10)
	slider.add_theme_stylebox_override("grabber_area", grabber_style)
	
	var highlight_style := StyleBoxFlat.new()
	highlight_style.bg_color = Color(1,1,1,1)
	highlight_style.set_expand_margin(SIDE_TOP, 2)
	highlight_style.set_expand_margin(SIDE_BOTTOM, 2)
	highlight_style.set_corner_radius_all(10)
	slider.add_theme_stylebox_override("grabber_highlight", highlight_style)


func _style_label(label: Label) -> void:
	if button_font:
		label.add_theme_font_override("font", button_font)
	label.add_theme_font_size_override("font_size", 30)
	label.add_theme_color_override("font_color", OUTLINE)


func _on_back_pressed() -> void:
	ButtonClick.play()
	get_tree().change_scene_to_file("res://main_menu.tscn")
