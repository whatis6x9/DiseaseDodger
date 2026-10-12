extends Label

func _physics_process(delta: float) -> void:
	$".".text = str($"../../GameTimeout".time_left).pad_decimals(2)
