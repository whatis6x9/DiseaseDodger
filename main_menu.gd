extends Control
const SlimeCover := preload("res://slime_cover.tscn")
@export var button_font: Font

const OUTLINE := Color("1b6ca8")
const NORMAL := Color("bfe9ff")
const HOVER := Color("e8fbff")
const PRESSED := Color("8fd3f5")

var title: Label
var buttons: Array[Button] = []


func _ready() -> void:
	for child in $VBoxContainer.get_children():
		if child is Button:
			_style_button(child)
			buttons.append(child as Button)
		elif child is Label and title == null:
			title = child as Label
	_play_intro()


func _play_intro() -> void:
	var items: Array[Control] = []
	if title:
		items.append(title)
	for button in buttons:
		items.append(button)

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


func _on_start_pressed() -> void:
	_spawn_slime($VBoxContainer/Start)
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Scenes/Map1.tscn")

func _on_quit_pressed() -> void:
	_spawn_slime($VBoxContainer/Quit)
	get_tree().quit()


func _on_options_pressed() -> void:
	_spawn_slime($VBoxContainer/Options)
	get_tree().change_scene_to_file("res://Scenes/options.tscn")
	print("Options pressed")


func _spawn_slime(button: Button) -> void:
	var cover := SlimeCover.instantiate()
	add_child(cover)
	cover.z_index = 10
	cover.play(button.global_position, button.size, get_viewport_rect().size.y)
