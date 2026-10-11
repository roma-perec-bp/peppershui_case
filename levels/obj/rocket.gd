extends CharacterBody2D
var isded:bool = false
func _ready() -> void:
	velocity.y = 200
	await TimerRoot.delay(1)
	$fall.play()
	velocity.y = 999
	
func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if isded:
		return
	if body.name == 'player_exe':
		body._damage()
		body._damage()
		body._damage()
		$Sprite2D.visible = false
		$explosion.visible = true
		$explosion.play("default")
		velocity.y = 0
		isded = true
		$explosion_snd.play()
		
	if body.name == 'floor':
		$Sprite2D.visible = false
		$explosion.visible = true
		$explosion.play("default")
		
		$ColorRect.self_modulate.a = 1
		velocity.y = 0
		isded = true
		$explosion_snd.play()
		
		var tween = get_tree().create_tween()
		tween.tween_property($ColorRect, "self_modulate:a", 0, 0.5)


func _on_explosion_animation_finished() -> void:
	queue_free()
