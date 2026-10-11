extends RigidBody2D


func _ready() -> void:
	await TimerRoot.delay(10)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 3)
	await TimerRoot.delay(3)
	queue_free()

func set_property(textu:int):
	$Sprite2D.texture = load("res://images/gibs/body_part"+str(textu)+".png")
	
	var direction: Vector2 = global_position - Vector2(randf_range(-1, 1), randf_range(-1, 1))
	apply_impulse(direction.normalized() * 1000)
