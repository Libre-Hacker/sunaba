extends Node

var viewport_start_size := Vector2(
	ProjectSettings.get_setting(&"display/window/size/viewport_width"),
	ProjectSettings.get_setting(&"display/window/size/viewport_height")
)

func scale(index: int) -> void:
	# For changing the UI, we take the viewport size, which we set in the project settings.
	var new_size := viewport_start_size
	if index == 0: # Smaller (66%)
		new_size *= 1.5
	elif index == 1: # Small (80%)
		new_size *= 1.25
	elif index == 2: # Medium (100%) (default)
		new_size *= 1.0
	elif index == 3: # Large (133%)
		new_size *= 0.75
	elif index == 4: # Larger (200%)
		new_size *= 0.5
	get_tree().root.set_content_scale_size(new_size)
