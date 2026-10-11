extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ghost()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_property(pos):
	global_position = pos
	
func ghost():
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self, "self_modulate:a", 0, 1)
	await tween_fade.finished
	
	queue_free()
