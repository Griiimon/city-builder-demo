extends Control



func _draw():
	for size in [128, 256, 512]:
		draw_rect(Rect2(-Vector2.ONE * size / 2, Vector2.ONE * size), Color.WHITE, false)
