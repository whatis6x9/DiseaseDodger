extends Node2D

@onready var blob: Polygon2D = $Blob


func setup(size: Vector2) -> void:
	var points := PackedVector2Array()
	points.append(Vector2(0, 0))
	points.append(Vector2(size.x, 0))

	var drip_count := 6
	for i in range(drip_count + 1):
		var x := size.x * (1.0 - float(i) / drip_count)
		var drip_len := randf_range(size.y * 0.9, size.y * 1.6)
		points.append(Vector2(x, drip_len))
		if i < drip_count:
			var mid_x := size.x * (1.0 - (float(i) + 0.5) / drip_count)
			points.append(Vector2(mid_x, size.y * 0.75))

	blob.polygon = points


func play(button_global_pos: Vector2, size: Vector2, screen_height: float) -> void:
	global_position = button_global_pos
	setup(size)
	blob.scale = Vector2(1, 0.05)

	var mat := blob.material as ShaderMaterial
	mat.set_shader_parameter("shine_pos", -0.2)

	var pop := create_tween()
	pop.tween_property(blob, "scale", Vector2.ONE, 0.15) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	pop.parallel().tween_method(
		func(v): mat.set_shader_parameter("shine_pos", v), -0.2, 0.6, 0.4)
	await pop.finished

	await get_tree().create_timer(0.5).timeout

	var slide := create_tween()
	slide.tween_property(self, "position:y", screen_height + 100, 0.9) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await slide.finished
	queue_free()
