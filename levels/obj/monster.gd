extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO

var dead:bool = false

var big:bool = false

var gib=load("res://levels/obj/body_gib.tscn")

func _ready() -> void:
	if randi() % 2:
		big = true    
		
	if big:
		$AnimatedSprite2D.play("big")
		$sight_big.play()
	else:
		$AnimatedSprite2D.play("small")
		$sight_small.play()
		
	randomPath()
	
func randomPath():
	if randf() < 0.5:
		velocity.x = randf_range(100, 300)
	else:
		velocity.x = randf_range(-100, -300)
		
	if randf() < 0.5:
		velocity.y = randf_range(100, 300)
	else:
		velocity.y = randf_range(-100, -300)
		
	await get_tree().create_timer(randf_range(1, 3)).timeout
	if !dead: randomPath()
		

func _physics_process(delta: float) -> void:
	#velocity = direction
	
	if !dead: move_and_slide()

func _on_animated_sprite_2d_2_animation_finished() -> void:
	$AnimatedSprite2D2.visible = false


func _on_dead_trigger_body_entered(body: Node2D) -> void:
	if body.name == 'player_umbra' and body.canMove and !dead:
		$marker.queue_free()
		body.kill()
		if big:
			var inst = gib.instantiate()
			inst.set_property(3)
			inst.position = $gib.global_position
			get_parent().call_deferred("add_child", inst);
			
			var inst1 = gib.instantiate()
			inst1.set_property(4)
			inst1.position = $gib.global_position
			get_parent().call_deferred("add_child", inst1);
			
			var inst2 = gib.instantiate()
			inst2.set_property(5)
			inst2.position = $gib.global_position
			get_parent().call_deferred("add_child", inst2);
			
			var inst3 = gib.instantiate()
			inst3.set_property(6)
			inst3.position = $gib.global_position
			get_parent().call_deferred("add_child", inst3);
			
			var inst4 = gib.instantiate()
			inst4.set_property(7)
			inst4.position = $gib.global_position
			get_parent().call_deferred("add_child", inst4);
			
			var inst5 = gib.instantiate()
			inst5.set_property(8)
			inst5.position = $gib.global_position
			get_parent().call_deferred("add_child", inst5);
			
			var inst6 = gib.instantiate()
			inst6.set_property(9)
			inst6.position = $gib.global_position
			get_parent().call_deferred("add_child", inst6);
		else:
			var inst = gib.instantiate()
			inst.set_property(0)
			inst.position = $gib.global_position
			get_parent().call_deferred("add_child", inst);
			
			var inst1 = gib.instantiate()
			inst1.set_property(1)
			inst1.position = $gib.global_position
			get_parent().call_deferred("add_child", inst1);
			
			var inst2 = gib.instantiate()
			inst2.set_property(2)
			inst2.position = $gib.global_position
			get_parent().call_deferred("add_child", inst2);
		
		$kill.play()
		
		if big:
			$scream_big.play()
		else:
			$scream_small.play()
				
			
		dead = true
		$AnimatedSprite2D.visible = false
		$AnimatedSprite2D2.visible = true
		$AnimatedSprite2D2.play("0")
		
		$blood.rotation = randf_range(-360, 360)
		
		var scaleSwag:float = randf_range(0.8, 2)
		var scaleTime:float = randi_range(1,2)
		var tween = get_tree().create_tween()
		tween.tween_property($blood, "scale:x", scaleSwag, scaleTime)
		var tween2 = get_tree().create_tween()
		tween2.tween_property($blood, "scale:y", scaleSwag, scaleTime)
