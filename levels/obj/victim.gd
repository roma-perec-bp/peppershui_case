extends CharacterBody2D

signal onDead

var direction: Vector2 = Vector2.ZERO

var dead:bool = false

func _ready() -> void:
	$blood.frame = randi_range(0,3)
	$AnimatedSprite2D.play(str(randi_range(0,3)))
	randomPath()
	
func randomPath():
	if randf() < 0.5:
		velocity.x = 200
	else:
		velocity.x = -200
		
	if randf() < 0.5:
		velocity.y = 200
	else:
		velocity.y = -200
		
	await get_tree().create_timer(randf_range(1, 3)).timeout
	if !dead: randomPath()
		

func _physics_process(delta: float) -> void:
	#velocity = direction
	
	if !dead: move_and_slide()

func _on_animated_sprite_2d_2_animation_finished() -> void:
	$AnimatedSprite2D2.visible = false


func _on_dead_trigger_body_entered(body: Node2D) -> void:
	if body.name == 'player_perec' and body.canMove and !dead:
		$marker.queue_free()
		$kill.play()
		$scream.play()
		dead = true
		emit_signal("onDead")
		$AnimatedSprite2D.visible = false
		$Sprite2D.visible = true
		$AnimatedSprite2D2.visible = true
		$AnimatedSprite2D2.play(str(randi_range(0,1)))
		
		var scaleSwag:float = randf_range(0.8, 1.2)
		var scaleTime:float = randi_range(10,30)
		var tween = get_tree().create_tween()
		tween.tween_property($blood, "scale:x", scaleSwag, scaleTime)
		var tween2 = get_tree().create_tween()
		tween2.tween_property($blood, "scale:y", scaleSwag, scaleTime)
